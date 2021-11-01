//
//  SpaceyViewModel.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 14/04/21.
//

import Foundation

import YDExtensions
import YDB2WModels
import YDUtilities
import YDB2WServices
import YDB2WIntegration

public protocol YDSpaceyViewModelDelegate: AnyObject {
  var loading: Binder<Bool> { get }
  var error: Binder<String> { get }
  var spacey: Binder<YDB2WModels.YDSpacey?> { get }
  var spaceyId: String { get }
  
  var bannerDelegate: YDSpaceyViewModelBannerDelegate? { get set }
  var nextLiveDelegate: YDSpaceyViewModelNextLiveDelegate? { get set }
  var productDelegate: YDSpaceyViewModelProductDelegate? { get set }
  var liveNPSDelegate: YDSpaceyViewModelLiveNPSDelegate? { get set }
  
  var componentsList: Binder<[YDSpaceyCommonStruct]> { get set }
  var playerComponent: Binder<YDSpaceyComponentPlayer?> { get }
  var firstNextLive: Binder<YDSpaceyComponentNextLive?> { get }

  var bannersOnList: [Int: YDSpaceyBannerConfig] { get set }
  
  var productsBatchesSize: Int { get }
  var carrouselProducts: [Int: YDSpaceyProductCarrouselContainer] { get set }
  
  var spaceyOrder: [String] { get }
  var spaceyNPSPreviewQuantity: Int { get }

  func getSpacey(withId id: String, customApi: String?)
  func getSpacey()
  func getComponentAndType(
    at indexPath: IndexPath
  ) -> (
    component: YDSpaceyComponentDelegate?,
    type: YDSpaceyComponentsTypes.Types?
  )
  
  func openNextLives()
  func saveNextLiveOnCalendar(
    live: YDSpaceyComponentNextLive,
    onCompletion completion: @escaping (_ success: Bool) -> Void
  )
  
  func getProductsIds(
    at: Int,
    onCompletion: @escaping ([(id: String, sellerId: String)]) -> Void
  )
  func getProducts(
    ofIds ids: [(id: String, sellerId: String)],
    at: Int,
    onCompletion completion: @escaping (Result<[YDSpaceyProduct], YDServiceError>) -> Void
  )
  func selectProductOnCarrousel(_ product: YDSpaceyProduct)
  func onAddProductToCart(_ product: YDSpaceyProduct, with parameters: [String : Any])
  func onTapProductCoupon(_ product: YDSpaceyProduct)
  func onOpenBanner(with url: String?)
  func sendLiveNPS(with nps: YDSpaceyComponentLiveNPSCard?)
}

public class YDSpaceyViewModel {
  // Properties
  lazy var logger = Logger.forClass(Self.self)
  let service: YDB2WServiceDelegate
  let supportedTypes: [YDSpaceyComponentsTypes.Types]
  let supportedNPSAnswersTypes: [YDSpaceyComponentNPSQuestion.AnswerTypeEnum]
  
  public weak var bannerDelegate: YDSpaceyViewModelBannerDelegate?
  public weak var nextLiveDelegate: YDSpaceyViewModelNextLiveDelegate?
  public weak var productDelegate: YDSpaceyViewModelProductDelegate?
  public weak var liveNPSDelegate: YDSpaceyViewModelLiveNPSDelegate?

  public var loading: Binder<Bool> = Binder(false)
  public var error: Binder<String> = Binder("")
  public var spacey: Binder<YDB2WModels.YDSpacey?> = Binder(nil)
  public var componentsList: Binder<[YDSpaceyCommonStruct]> = Binder([])
  public var playerComponent: Binder<YDSpaceyComponentPlayer?> = Binder(nil)
  public var firstNextLive: Binder<YDSpaceyComponentNextLive?> = Binder(nil)

  public var bannersOnList: [Int: YDSpaceyBannerConfig] = [:]
  
  public var carrouselProducts: [Int: YDSpaceyProductCarrouselContainer] = [:]
  public var productsBatchesSize = 5
  
  public var spaceyOrder: [String] = []
  public var spaceyId = ""
  public var spaceyNPSPreviewQuantity = 0

  // Init
  public init(
    service: YDB2WServiceDelegate = YDB2WService(),
    supportedTypes: [YDSpaceyComponentsTypes.Types]?,
    supportedNPSAnswersTypes: [YDSpaceyComponentNPSQuestion.AnswerTypeEnum]?
  ) {
    self.service = service
    self.supportedTypes = supportedTypes ?? YDSpaceyComponentsTypes.Types.allCases
    self.supportedNPSAnswersTypes = supportedNPSAnswersTypes ?? YDSpaceyComponentNPSQuestion.AnswerTypeEnum.allCases
    
    if let spaceyOrder = YDIntegrationHelper.shared
        .getFeature(featureName: YDConfigKeys.spaceyService.rawValue)?
        .extras?[YDConfigProperty.liveSpaceyOrder.rawValue] as? [String] {
      self.spaceyOrder = spaceyOrder
    }
    
    if let productsBatchesSize = YDIntegrationHelper.shared
        .getFeature(featureName: YDConfigKeys.live.rawValue)?
        .extras?[YDConfigProperty.liveCarrouselProductsBatches.rawValue] as? Int {
      self.productsBatchesSize = productsBatchesSize
    }
  }

  // MARK: Actions
  func buildList(with spacey: YDB2WModels.YDSpacey) {
    var list: [YDSpaceyCommonStruct] = []
    var components: [YDSpaceyCommonStruct] = []

    if spaceyOrder.isEmpty {
      components = spacey.allComponents()
    } else {
      var tempList: [[String: YDSpaceyCommonStruct]] = []
      for property in spaceyOrder {
        if let obj = spacey[property] {
          tempList.append([property: obj])
        }
      }

      let filteredList = spacey.items.filter { curr in
        return !tempList.contains(where: { $0.keys.first == curr.key })
      }.compactMap { $0.value }

      components = tempList.map { $0.values.first }.compactMap { $0 }
      for curr in filteredList {
        components.append(curr)
      }
    }

    for curr in components {
      guard let type = curr.component?.type,
        supportedTypes.contains(type),
        let children = curr.component?.children
      else {
        continue
      }

      if type == .nps,
         let npsComponent = curr.component as? YDSpaceyComponentNPS,
         let quantity = npsComponent.previewQuantity {
        self.spaceyNPSPreviewQuantity = quantity
      }

      switch type {
        case .bannerCarrousel:
          list.append(curr)

        case .productCarrousel:
          list.append(curr)

          #warning("STAND BY")
//        case .grid:
//          curr.component?.children = conformSupportedTimesInside(children: children)
//          if (curr.component?.children ?? []).isEmpty {
//            continue
//          } else {
//            list.append(curr)
//          }

        case .liveNPS:
          list.append(curr)

        case .termsOfUse:
          list.append(curr)

        case .custom:
          list.append(curr)

        case .nextLiveParent:
          if let component = curr.component?.children
              .first?.get() as? YDSpaceyComponentNextLive {
            firstNextLive.value = component
          } else {
            firstNextLive.value = nil
          }
          
          list.append(curr)

        default:
          for component in children {
            if let data = buildData(from: component, parent: curr) {
              list.append(data)
            }
          }
      }
    }

    componentsList.value = list
  }

  func conformSupportedTypesInside(
    children: [YDSpaceyComponentsTypes]
  ) -> [YDSpaceyComponentsTypes] {
    return children.filter {
      if supportedTypes.contains($0.componentType) {
        if $0.componentType == .player,
           let player = $0.get() as? YDSpaceyComponentPlayer {
          playerComponent.value = player
          return false
        } else if $0.componentType == .grid,
                  let grid = $0.get() as? YDSpaceyComponentGrid {
          grid.children = conformSupportedTypesInside(children: grid.children)
          return true
        } else {
          return true
        }
      }

      return false
    }
  }

  func buildData(
    from component: YDSpaceyComponentsTypes,
    parent: YDSpaceyCommonStruct
  ) -> YDSpaceyCommonStruct? {
    if !supportedTypes.contains(component.componentType) { return nil }

    switch component {
      case .banner(let banner):
        let obj = extractData(from: banner)
        obj.children = [component]
        return YDSpaceyCommonStruct(id: obj.id, component: obj)

      case .bannerCarrousel:
        return parent

      case .player(let player):
        playerComponent.value = player

      case .title(let title):
        let obj = extractData(from: title)
        obj.children = [component]

        return YDSpaceyCommonStruct(id: obj.id, component: obj)

      case .nps(let nps):
        for curr in nps.children {
          return buildData(from: curr, parent: parent)
        }

      case .npsQuestion(let nps):
        if supportedNPSAnswersTypes.isEmpty {
          return YDSpaceyCommonStruct(id: nps.id, component: nps)
        } else {
          if supportedNPSAnswersTypes.contains(nps.answerType) {
            return YDSpaceyCommonStruct(id: nps.id, component: nps)
          }
        }

      case .npsEditText(let nps):
        if supportedNPSAnswersTypes.isEmpty {
          return YDSpaceyCommonStruct(id: nps.id, component: nps)
        } else {
          if supportedNPSAnswersTypes.contains(nps.answerType) {
            return YDSpaceyCommonStruct(id: nps.id, component: nps)
          }
        }

      default:
        return nil
    }

    return nil
  }
  
  private func makeSpaceyRequest(customApi: String? = nil) {
    loading.value = true
    
    service.getSpacey(
      spaceyId: spaceyId,
      customApi: customApi
    ) { [weak self] (response: Result<YDB2WModels.YDSpacey, YDB2WServices.YDServiceError>) in
      guard let self = self else { return }
      switch response {
        case .success(let spacey):
          self.buildList(with: spacey)
          self.spacey.value = spacey
//          guard let spaceyMock = self.mock() else { return }
//          self.buildList(with: spaceyMock)
//          self.spacey.value = spaceyMock

        case .failure(let error):
          self.error.value = error.message
          self.loading.value = false
      }
    }
  }
}

// MARK: Extract SpaceyCommonComponent
public extension YDSpaceyViewModel {
  // Banner
  func extractData(from banner: YDSpaceyComponentBanner) -> YDSpaceyCommonComponent {
    return YDSpaceyCommonComponent(
      id: banner.id,
      children: [],
      type: banner.componentType
    )
  }

  // Title
  func extractData(from title: YDSpaceyComponentTitle) -> YDSpaceyCommonComponent {
    return YDSpaceyCommonComponent(
      id: title.id,
      children: [],
      type: title.componentType
    )
  }
}

// MARK: Delegate
extension YDSpaceyViewModel: YDSpaceyViewModelDelegate {
  public func getSpacey(withId id: String, customApi: String? = nil) {
    spaceyId = id
    makeSpaceyRequest(customApi: customApi)
  }
  
  public func getSpacey() { makeSpaceyRequest() }

  public func getComponentAndType(
    at indexPath: IndexPath
  ) -> (
    component: YDSpaceyComponentDelegate?,
    type: YDSpaceyComponentsTypes.Types?
  ) {
    guard let parent = componentsList.value.at(indexPath.row),
          let type = parent.component?.type
    else {
      return (nil, nil)
    }
    return (parent.component, type)
  }
}

// MARK: Mock
public extension YDSpaceyViewModel {
  func mock() -> YDB2WModels.YDSpacey? {
    guard let json = """
    {
        "contenttop2": {
        "_id": "60896b97f995a7002fa3bfe1",
        "name": "hotsite live - banner full - seller - chat",
        "position": "contenttop2",
        "component": {
        "__v": 265,
        "_id": "60896b97f995a7002fa3bfd8",
        "brand": "5eab52da03b6e12b73efda50",
        "children": [
        {
            "alternateText": "produtos",
            "backgroundColor": "",
            "balloonsDescription": "",
            "balloonsTitle": "",
            "big": "",
            "children": [],
            "crmkey": "",
            "defaultSize": "small",
            "departamento": "",
            "extralarge": "",
            "hotsite": "",
            "idProduto": "",
            "large": "",
            "linha": "",
            "linkUrl": "acom://product/3543976085?chave=app_hs_dapp_0_1_aovivo_surpresa",
            "medium": "",
            "meta": {
            "small": {
            "height": 324,
            "width": 648
        }
        },
            "opa": "",
            "showBalloons": "não",
            "small": "https://images-americanas.b2w.io/spacey/acom/2021/10/27/8f51b9e5b081-destaque_produto_live_Casa_Mind_Oferta_Surpresa_27_10.png",
            "tag": "",
            "target": "Abrir na mesma aba",
            "title": "surpresa",
            "type": "zion-image"
        },
        {
            "_id": "614b32801a914c0030859728",
            "alternateText": "produtos",
            "backgroundColor": "",
            "balloonsDescription": "",
            "balloonsTitle": "",
            "big": "",
            "children": [],
            "crmkey": "",
            "defaultSize": "small",
            "departamento": "",
            "extralarge": "",
            "hotsite": "",
            "idProduto": "",
            "large": "",
            "linha": "",
            "linkUrl": "acom://navigation/https://www.americanas.com.br/hotsite/live-271021?chave=app_hs_dapp_0_1_aovivo",
            "medium": "",
            "meta": {
            "small": {
            "height": 324,
            "width": 648
        }
        },
            "opa": "",
            "showBalloons": "não",
            "small": "https://images-americanas.b2w.io/spacey/acom/2021/10/27/5065782e3c73-destaque_produto_live_Casa_Mind_27_10.png",
            "tag": "",
            "target": "Abrir na mesma aba",
            "title": "condição",
            "type": "zion-image"
        },
        {
            "_id": "614b32801a914c0030859729",
            "alternateText": "reclame aqui",
            "backgroundColor": "",
            "balloonsDescription": "",
            "balloonsTitle": "",
            "big": "",
            "children": [],
            "crmkey": "",
            "defaultSize": "small",
            "departamento": "",
            "extralarge": "",
            "hotsite": "",
            "idProduto": "",
            "large": "",
            "linha": "",
            "linkUrl": "https://bit.ly/3gOfghL",
            "medium": "",
            "meta": {
            "small": {
            "height": 324,
            "width": 648
        }
        },
            "opa": "",
            "showBalloons": "não",
            "small": "https://images-americanas.b2w.io/spacey/acom/2021/09/01/BANNER_PREMIO_RECLAME_AQUI_648x324px.png",
            "tag": "",
            "target": "Abrir na mesma aba",
            "title": "prêmio reclame aqui",
            "type": "zion-image"
        },
        {
            "_id": "614b32801a914c003085972a",
            "alternateText": "a mais",
            "backgroundColor": "",
            "balloonsDescription": "",
            "balloonsTitle": "",
            "big": "",
            "children": [],
            "crmkey": "",
            "defaultSize": "small",
            "departamento": "",
            "extralarge": "",
            "hotsite": "",
            "idProduto": "",
            "large": "",
            "linha": "",
            "linkUrl": "acom://navigation/http://venda.b2wmarketplace.com.br/vem-fazer-parte-do-americanas-ao-vivo?chave=am_hs_aovivo_seller",
            "medium": "",
            "meta": {
            "small": {
            "height": 270,
            "width": 648
        }
        },
            "opa": "",
            "showBalloons": "não",
            "small": "https://images-americanas.b2w.io/spacey/acom/2021/04/28/destaque_LIVE_B2B_APP.png",
            "tag": "",
            "target": "Abrir na mesma aba",
            "title": "mktplace",
            "type": "zion-image"
        }
        ],
        "columnTitle": "",
        "createdAt": "2016-11-21T14:59:04.607Z",
        "hr": "",
        "key1": "",
        "key2": "",
        "key3": "",
        "key4": "",
        "lg": "1",
        "md": "1",
        "meta": {
        "image": {
        "height": 216,
        "width": 648
    },
        "imageMobile": {
        "height": 216,
        "width": 648
    }
    },
        "options": "Espaçamento Externo, Espaçamento Interno, Espaçamento Lateral App, Bordas Arredondadas - App",
        "size": "Pequeno",
        "sm": "1",
        "textAlign": "Esquerda",
        "title": "",
        "type": "zion-grid",
        "updatedAt": "2021-09-22T13:41:20.607Z",
        "xs": "1"
    }
    },
        "hotsiteconfig": {
        "_id": "5f358956e6ad000035a833e4",
        "name": "[LIVE] Hotsite",
        "position": "hotsiteconfig",
        "component": {
        "__v": 0,
        "_id": "5f3589560764780036ba15aa",
        "amePromoted": "",
        "brand": "5eab52da03b6e12b73efda50",
        "categoryId": "",
        "children": [],
        "content": "",
        "createdAt": "2020-08-13T18:41:26.515Z",
        "gridTag": "",
        "hasSidebar": "",
        "hotsiteModel": "",
        "hotsiteTitle": "Live ao vivo",
        "meta": "",
        "options": "",
        "sellerId": "",
        "showBrandCardInstallment": "",
        "showCategories": "sim",
        "tagCardType": "",
        "title": "Teste y/d",
        "type": "zion-hotsite",
        "updatedAt": "2020-08-13T20:35:13.486Z"
    }
    },
        "live-schedule": {
        "_id": "60904c8ee67512002fb609de",
        "name": "[TESTE] hotsite-live-teste-nativo-schedule-data (live)",
        "position": "live-schedule",
        "component": {
        "__v": 82,
        "_id": "60904c8ee67512002fb609cb",
        "brand": "5eab52da03b6e12b73efda50",
        "children": [
        {
            "_id": "61732a37f587e800119fc945",
            "children": [],
            "liveDescription": "especial mulher: autocuidado que cabe no bolso",
            "liveEndTime": "25/10/2021 13:00",
            "liveImageUrl": "https://images-americanas.b2w.io/spacey/acom/2021/10/22/4c4dc96f72da-atracao_calendario_proxima_live_464x464px_Americanas_25_10.png",
            "liveStartTime": "25/10/2021 12:00",
            "liveTitle": "americanas",
            "meta": {
            "liveImageUrl": {
            "height": 464,
            "width": 464
        }
        },
            "title": "shop b",
            "type": "live-schedule-item"
        },
        {
            "_id": "61732a37f587e800119fc946",
            "children": [],
            "liveDescription": "o suplemento ideal pra te ajudar na rotina de exercícios",
            "liveEndTime": "25/10/2021 16:00",
            "liveImageUrl": "https://images-americanas.b2w.io/spacey/acom/2021/09/29/f61aa0bd3d9d-atracao_calendario_proxima_live_464x464px_WebNutrition_28_09.png",
            "liveStartTime": "25/10/2021 15:00",
            "liveTitle": "WebNutrition",
            "meta": {
            "liveImageUrl": {
            "height": 464,
            "width": 464
        }
        },
            "title": "webnutrition",
            "type": "live-schedule-item"
        },
        {
            "_id": "61732a37f587e800119fc947",
            "children": [],
            "liveDescription": "sono dos sonhos com o colchão certo pra você",
            "liveEndTime": "26/10/2021 20:00",
            "liveImageUrl": "https://images-americanas.b2w.io/spacey/acom/2021/10/22/bf00ea1be81f-atracao_calendario_proxima_live_464x464px_Emma_Colchoes_26_10.png",
            "liveStartTime": "26/10/2021 19:00",
            "liveTitle": "Emma Colchões",
            "meta": {
            "liveImageUrl": {
            "height": 464,
            "width": 464
        }
        },
            "title": "emma colchoes",
            "type": "live-schedule-item"
        },
        {
            "_id": "61732a37f587e800119fc948",
            "children": [],
            "liveDescription": "dicas e truques pra renovar a decoração da sua casa em poucos passos",
            "liveEndTime": "27/10/2021 16:00",
            "liveImageUrl": "https://images-americanas.b2w.io/spacey/acom/2021/09/29/7e081fc00d1c-atracao_calendario_proxima_live_464x464px_WP_Mind_15_09.png",
            "liveStartTime": "27/10/2021 15:00",
            "liveTitle": "Casa Mind",
            "meta": {
            "liveImageUrl": {
            "height": 464,
            "width": 464
        }
        },
            "title": "casamind",
            "type": "live-schedule-item"
        },
        {
            "_id": "61732a37f587e800119fc949",
            "children": [],
            "liveDescription": "descubra a bebida que mais combina com seu paladar",
            "liveEndTime": "28/10/2021 20:00",
            "liveImageUrl": "https://images-americanas.b2w.io/spacey/acom/2021/09/29/2b660d4384e9-atracao_calendario_proxima_live_464x464px.png",
            "liveStartTime": "28/10/2021 19:00",
            "liveTitle": "The Bar",
            "meta": {
            "liveImageUrl": {
            "height": 464,
            "width": 464
        }
        },
            "title": "the bar",
            "type": "live-schedule-item"
        },
        {
            "_id": "61732a37f587e800119fc94a",
            "children": [],
            "liveDescription": "top 15 títulos nacionais para comemorar o Dia Nacional do Livro",
            "liveEndTime": "29/10/2021 16:00",
            "liveImageUrl": "https://images-americanas.b2w.io/spacey/acom/2021/09/29/99c6b88a4b24-atracao_calendario_proxima_live_464x464px.png",
            "liveStartTime": "29/10/2021 15:00",
            "liveTitle": "Ana Clara",
            "meta": {
            "liveImageUrl": {
            "height": 464,
            "width": 464
        }
        },
            "title": "ana clara",
            "type": "live-schedule-item"
        }
        ],
        "createdAt": "2021-03-31T21:29:53.241Z",
        "liveTitle": "fica de olho na próxima live :)",
        "nextLiveButtonTitle": "confira nossa programação completa",
        "showOnlyFirstItem": "não",
        "title": "Nome da area",
        "type": "live-schedule",
        "updatedAt": "2021-09-22T15:59:07.025Z"
    }
    },
        "maintop1": {
        "_id": "6086fec25a01f80035daccba",
        "name": "[TESTE 2] hotsite-live-teste-nativo-video",
        "position": "maintop1",
        "component": {
        "__v": 213,
        "_id": "6086fec15a01f80035daccb5",
        "brand": "5eab52da03b6e12b73efda50",
        "children": [
        {
            "_id": "614b42b01a914c003085991e",
            "children": [],
            "meta": "",
            "size": "LARGE",
            "title": "video teste",
            "type": "zion-video",
            "videoURL": "https://youtu.be/2iEPnZEqnxM"
        }
        ],
        "columnTitle": "",
        "createdAt": "2020-08-13T20:46:09.129Z",
        "hr": "",
        "key1": "",
        "key2": "",
        "key3": "",
        "key4": "",
        "lg": "Padrão",
        "md": "Padrão",
        "options": "",
        "size": "Pequeno",
        "sm": "Padrão",
        "textAlign": "Esquerda",
        "title": "Nome da area",
        "type": "zion-grid",
        "updatedAt": "2021-09-22T14:50:24.296Z",
        "xs": "Padrão"
    }
    },
        "maintop2": {
        "_id": "5f31be3e80a84a002f7942e9",
        "name": "hotsite live - carrossel 1",
        "position": "maintop2",
        "component": {
        "__v": 722,
        "_id": "5f31be3dddd5ab002fe2ae1b",
        "brand": "5eab52da03b6e12b73efda50",
        "children": [
        {
            "backgroundColor": "",
            "backgroundImage": "",
            "children": [],
            "coupon": "CUPOMTESTE",
            "couponDeeplink": "acom://navigation/https://www.americanas.com.br/hotsite/live-261021?chave=app_hs_dapp_0_1_aovivo",
            "crmkey": "",
            "featuredOfferText": "",
            "featuredOfferType": "",
            "finalDate": "",
            "href": "",
            "options": "",
            "orientation": "column",
            "pitType": "",
            "price_apponly": "",
            "productId": "3543976085",
            "sellerId": "399603000612",
            "spaceyQS": [],
            "tag": "",
            "themeText": "dark",
            "title": "1",
            "type": "zion-product"
        },
        {
            "backgroundColor": "",
            "backgroundImage": "",
            "children": [],
            "coupon": "CUPOMTESTE",
            "couponDeeplink": "acom://navigation/https://www.americanas.com.br/hotsite/live-261021?chave=app_hs_dapp_0_1_aovivo",
            "crmkey": "",
            "featuredOfferText": "",
            "featuredOfferType": "",
            "finalDate": "",
            "href": "",
            "options": "",
            "orientation": "column",
            "pitType": "",
            "price_apponly": "",
            "productId": "4071291079",
            "sellerId": "399603000612",
            "spaceyQS": [],
            "tag": "",
            "themeText": "dark",
            "title": "2",
            "type": "zion-product"
        },
        {
            "backgroundColor": "",
            "backgroundImage": "",
            "children": [],
            "coupon": "CUPOMTESTE",
            "couponDeeplink": "acom://navigation/https://www.americanas.com.br/hotsite/live-261021?chave=app_hs_dapp_0_1_aovivo",
            "crmkey": "",
            "featuredOfferText": "",
            "featuredOfferType": "",
            "finalDate": "",
            "href": "",
            "options": "",
            "orientation": "column",
            "pitType": "",
            "price_apponly": "",
            "productId": "3745067120",
            "sellerId": "399603000612",
            "spaceyQS": [],
            "tag": "",
            "themeText": "dark",
            "title": "3",
            "type": "zion-product"
        },
        {
            "backgroundColor": "",
            "backgroundImage": "",
            "children": [],
            "coupon": "CUPOMTESTE",
            "couponDeeplink": "acom://navigation/https://www.americanas.com.br/hotsite/live-261021?chave=app_hs_dapp_0_1_aovivo",
            "crmkey": "",
            "featuredOfferText": "",
            "featuredOfferType": "",
            "finalDate": "",
            "href": "",
            "options": "",
            "orientation": "column",
            "pitType": "",
            "price_apponly": "",
            "productId": "3686657461",
            "sellerId": "399603000612",
            "spaceyQS": [],
            "tag": "",
            "themeText": "dark",
            "title": "4",
            "type": "zion-product"
        },
        {
            "backgroundColor": "",
            "backgroundImage": "",
            "children": [],
            "coupon": "CUPOMTESTE",
            "couponDeeplink": "acom://navigation/https://www.americanas.com.br/hotsite/live-261021?chave=app_hs_dapp_0_1_aovivo",
            "crmkey": "",
            "featuredOfferText": "",
            "featuredOfferType": "",
            "finalDate": "",
            "href": "",
            "options": "",
            "orientation": "column",
            "pitType": "",
            "price_apponly": "",
            "productId": "3042900664",
            "sellerId": "399603000612",
            "spaceyQS": [],
            "tag": "",
            "themeText": "dark",
            "title": "5",
            "type": "zion-product"
        },
        {
            "backgroundColor": "",
            "backgroundImage": "",
            "children": [],
            "coupon": "CUPOMTESTE",
            "couponDeeplink": "acom://navigation/https://www.americanas.com.br/hotsite/live-261021?chave=app_hs_dapp_0_1_aovivo",
            "crmkey": "",
            "featuredOfferText": "",
            "featuredOfferType": "",
            "finalDate": "",
            "href": "",
            "options": "",
            "orientation": "column",
            "pitType": "",
            "price_apponly": "",
            "productId": "3745080981",
            "sellerId": "399603000612",
            "spaceyQS": [],
            "tag": "",
            "themeText": "dark",
            "title": "6",
            "type": "zion-product"
        },
        {
            "backgroundColor": "",
            "backgroundImage": "",
            "children": [],
            "coupon": "CUPOMTESTE",
            "couponDeeplink": "acom://navigation/https://www.americanas.com.br/hotsite/live-261021?chave=app_hs_dapp_0_1_aovivo",
            "crmkey": "",
            "featuredOfferText": "",
            "featuredOfferType": "",
            "finalDate": "",
            "href": "",
            "options": "",
            "orientation": "column",
            "pitType": "",
            "price_apponly": "",
            "productId": "3686655393",
            "sellerId": "399603000612",
            "spaceyQS": [],
            "tag": "",
            "themeText": "dark",
            "title": "7",
            "type": "zion-product"
        },
        {
            "backgroundColor": "",
            "backgroundImage": "",
            "children": [],
            "coupon": "CUPOMTESTE",
            "couponDeeplink": "acom://navigation/https://www.americanas.com.br/hotsite/live-261021?chave=app_hs_dapp_0_1_aovivo",
            "crmkey": "",
            "featuredOfferText": "",
            "featuredOfferType": "",
            "finalDate": "",
            "href": "",
            "options": "",
            "orientation": "column",
            "pitType": "",
            "price_apponly": "",
            "productId": "3745062610",
            "sellerId": "399603000612",
            "spaceyQS": [],
            "tag": "",
            "themeText": "dark",
            "title": "8",
            "type": "zion-product"
        },
        {
            "backgroundColor": "",
            "backgroundImage": "",
            "children": [],
            "coupon": "CUPOMTESTE",
            "couponDeeplink": "acom://navigation/https://www.americanas.com.br/hotsite/live-261021?chave=app_hs_dapp_0_1_aovivo",
            "crmkey": "",
            "featuredOfferText": "",
            "featuredOfferType": "",
            "finalDate": "",
            "href": "",
            "options": "",
            "orientation": "column",
            "pitType": "",
            "price_apponly": "",
            "productId": "3686657831",
            "sellerId": "399603000612",
            "spaceyQS": [],
            "tag": "",
            "themeText": "dark",
            "title": "9",
            "type": "zion-product"
        },
        {
            "backgroundColor": "",
            "backgroundImage": "",
            "children": [],
            "coupon": "CUPOMTESTE",
            "couponDeeplink": "acom://navigation/https://www.americanas.com.br/hotsite/live-261021?chave=app_hs_dapp_0_1_aovivo",
            "crmkey": "",
            "featuredOfferText": "",
            "featuredOfferType": "",
            "finalDate": "",
            "href": "",
            "options": "",
            "orientation": "column",
            "pitType": "",
            "price_apponly": "",
            "productId": "3686654657",
            "sellerId": "399603000612",
            "spaceyQS": [],
            "tag": "",
            "themeText": "dark",
            "title": "10",
            "type": "zion-product"
        },
        {
            "backgroundColor": "",
            "backgroundImage": "",
            "children": [],
            "coupon": "CUPOMTESTE",
            "couponDeeplink": "acom://navigation/https://www.americanas.com.br/hotsite/live-261021?chave=app_hs_dapp_0_1_aovivo",
            "crmkey": "",
            "featuredOfferText": "",
            "featuredOfferType": "",
            "finalDate": "",
            "href": "",
            "options": "",
            "orientation": "column",
            "pitType": "",
            "price_apponly": "",
            "productId": "3042864835",
            "sellerId": "399603000612",
            "spaceyQS": [],
            "tag": "",
            "themeText": "dark",
            "title": "11",
            "type": "zion-product"
        },
        {
            "backgroundColor": "",
            "backgroundImage": "",
            "children": [],
            "coupon": "CUPOMTESTE",
            "couponDeeplink": "acom://navigation/https://www.americanas.com.br/hotsite/live-261021?chave=app_hs_dapp_0_1_aovivo",
            "crmkey": "",
            "featuredOfferText": "",
            "featuredOfferType": "",
            "finalDate": "",
            "href": "",
            "options": "",
            "orientation": "column",
            "pitType": "",
            "price_apponly": "",
            "productId": "3042901106",
            "sellerId": "399603000612",
            "spaceyQS": [],
            "tag": "",
            "themeText": "dark",
            "title": "12",
            "type": "zion-product"
        },
        {
            "backgroundColor": "",
            "backgroundImage": "",
            "children": [],
            "coupon": "CUPOMTESTE",
            "couponDeeplink": "acom://navigation/https://www.americanas.com.br/hotsite/live-261021?chave=app_hs_dapp_0_1_aovivo",
            "crmkey": "",
            "featuredOfferText": "",
            "featuredOfferType": "",
            "finalDate": "",
            "href": "",
            "options": "",
            "orientation": "column",
            "pitType": "",
            "price_apponly": "",
            "productId": "3686655094",
            "sellerId": "399603000612",
            "spaceyQS": [],
            "tag": "",
            "themeText": "dark",
            "title": "13",
            "type": "zion-product"
        },
        {
            "backgroundColor": "",
            "backgroundImage": "",
            "children": [],
            "coupon": "CUPOMTESTE",
            "couponDeeplink": "acom://navigation/https://www.americanas.com.br/hotsite/live-261021?chave=app_hs_dapp_0_1_aovivo",
            "crmkey": "",
            "featuredOfferText": "",
            "featuredOfferType": "",
            "finalDate": "",
            "href": "",
            "options": "",
            "orientation": "column",
            "pitType": "",
            "price_apponly": "",
            "productId": "3686659319",
            "sellerId": "399603000612",
            "spaceyQS": [],
            "tag": "",
            "themeText": "dark",
            "title": "14",
            "type": "zion-product"
        },
        {
            "backgroundColor": "",
            "backgroundImage": "",
            "children": [],
            "coupon": "CUPOMTESTE",
            "couponDeeplink": "acom://navigation/https://www.americanas.com.br/hotsite/live-261021?chave=app_hs_dapp_0_1_aovivo",
            "crmkey": "",
            "featuredOfferText": "",
            "featuredOfferType": "",
            "finalDate": "",
            "href": "",
            "options": "",
            "orientation": "column",
            "pitType": "",
            "price_apponly": "",
            "productId": "3042891745",
            "sellerId": "399603000612",
            "spaceyQS": [],
            "tag": "",
            "themeText": "dark",
            "title": "15",
            "type": "zion-product"
        },
        {
            "backgroundColor": "",
            "backgroundImage": "",
            "children": [],
            "coupon": "CUPOMTESTE",
            "couponDeeplink": "acom://navigation/https://www.americanas.com.br/hotsite/live-261021?chave=app_hs_dapp_0_1_aovivo",
            "crmkey": "",
            "featuredOfferText": "",
            "featuredOfferType": "",
            "finalDate": "",
            "href": "",
            "options": "",
            "orientation": "column",
            "pitType": "",
            "price_apponly": "",
            "productId": "3042873598",
            "sellerId": "399603000612",
            "spaceyQS": [],
            "tag": "",
            "themeText": "dark",
            "title": "16",
            "type": "zion-product"
        },
        {
            "backgroundColor": "",
            "backgroundImage": "",
            "children": [],
            "coupon": "CUPOMTESTE",
            "couponDeeplink": "acom://navigation/https://www.americanas.com.br/hotsite/live-261021?chave=app_hs_dapp_0_1_aovivo",
            "crmkey": "",
            "featuredOfferText": "",
            "featuredOfferType": "",
            "finalDate": "",
            "href": "",
            "options": "",
            "orientation": "column",
            "pitType": "",
            "price_apponly": "",
            "productId": "3042887738",
            "sellerId": "399603000612",
            "spaceyQS": [],
            "tag": "",
            "themeText": "dark",
            "title": "17",
            "type": "zion-product"
        },
        {
            "backgroundColor": "",
            "backgroundImage": "",
            "children": [],
            "coupon": "CUPOMTESTE",
            "couponDeeplink": "acom://navigation/https://www.americanas.com.br/hotsite/live-261021?chave=app_hs_dapp_0_1_aovivo",
            "crmkey": "",
            "featuredOfferText": "",
            "featuredOfferType": "",
            "finalDate": "",
            "href": "",
            "options": "",
            "orientation": "column",
            "pitType": "",
            "price_apponly": "",
            "productId": "3042893901",
            "sellerId": "399603000612",
            "spaceyQS": [],
            "tag": "",
            "themeText": "dark",
            "title": "18",
            "type": "zion-product"
        },
        {
            "backgroundColor": "",
            "backgroundImage": "",
            "children": [],
            "coupon": "CUPOMTESTE",
            "couponDeeplink": "acom://navigation/https://www.americanas.com.br/hotsite/live-261021?chave=app_hs_dapp_0_1_aovivo",
            "crmkey": "",
            "featuredOfferText": "",
            "featuredOfferType": "",
            "finalDate": "",
            "href": "",
            "options": "",
            "orientation": "column",
            "pitType": "",
            "price_apponly": "",
            "productId": "3042891729",
            "sellerId": "399603000612",
            "spaceyQS": [],
            "tag": "",
            "themeText": "dark",
            "title": "19",
            "type": "zion-product"
        }
        ],
        "createdAt": "2020-06-15T12:11:53.475Z",
        "key": "",
        "showcaseTitle": "Confira os produtos da live",
        "sortBy": "Mais Relevantes",
        "tag": "",
        "title": "Nome da area ",
        "type": "live-carousel",
        "updatedAt": "2021-09-22T19:32:19.48Z"
    }
    }
    }
    """.data(using: .utf8),
      let spacey = try? JSONDecoder().decode(YDB2WModels.YDSpacey.self, from: json)
      else {
      return nil
    }

    return spacey
  }
}
