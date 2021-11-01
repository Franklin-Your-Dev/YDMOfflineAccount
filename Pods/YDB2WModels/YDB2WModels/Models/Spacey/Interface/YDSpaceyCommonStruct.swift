//
//  YDSpaceyCommonStruct.swift
//  YDB2WModels
//
//  Created by Douglas Hennrich on 12/05/21.
//

import Foundation

public class YDSpaceyCommonStruct: Decodable {
  public var id: String?
  public var component: YDSpaceyComponentDelegate?
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case component
  }
  
  public init(id: String?, component: YDSpaceyComponentDelegate) {
    self.id = id
    self.component = component
  }
  
  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try? container.decode(String.self, forKey: .id)
    
    guard let type = (try? container.decode(YDSpaceyCommonComponent.self, forKey: .component))?.type else {
      component = nil
      return
    }
    
    switch type {
      case .bannerCarrousel:
        component = try? container.decode(
          YDSpaceyComponentCarrouselBanner.self,
          forKey: .component
        )
        
      case .grid:
        component = try? container.decode(YDSpaceyComponentGrid.self, forKey: .component)
        
      case .liveNPS:
        component = try? container.decode(
          YDSpaceyComponentLiveNPS.self,
          forKey: .component
        )
        
      case .nextLiveParent:
        component = try? container.decode(
          YDSpaceyComponentNextLiveStruct.self,
          forKey: .component
        )
        
      case .productCarrousel:
        component = try? container.decode(
          YDSpaceyComponentCarrouselProduct.self,
          forKey: .component
        )
        
      case .termsOfUse:
        component = try? container.decode(YDSpaceyComponentTermsOfUse.self, forKey: .component)
        
      case .nps:
        component = try? container.decode(YDSpaceyComponentNPS.self, forKey: .component)
        
      default:
        component = try? container.decode(YDSpaceyCommonComponent.self, forKey: .component)
    }
  }
}
