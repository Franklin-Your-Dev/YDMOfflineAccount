//
//  YDMOfflineOrdersViewModel.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 21/02/21.
//

import UIKit

import YDUtilities
import YDExtensions
import YDB2WServices
import YDB2WModels
import YDB2WIntegration
import YDB2WDeepLinks
import YDMFindStore
import YDB2WComponents

// MARK: Navigation Delegate
protocol OfflineOrdersNavigationDelegate: AnyObject {
  func setNavigationController(_ navigation: UINavigationController?)
  func openDetailsForProduct(
    _ product: YDOfflineOrdersProduct,
    withinOrder order: YDOfflineOrdersOrder
  )
  func openDetailsForOrder(_ order: YDOfflineOrdersOrder, ordersInvoices: YDInvoices)
  func openQuiz()
  func onBack()
}

// MARK: ViewModel Delegate
protocol YDMOfflineOrdersViewModelDelegate: AnyObject {
  var error: Binder<String> { get }
  var errorDialog: Binder<(title: String?, message: String?)> { get }
  var loading: Binder<Bool> { get }
  var snackBar: Binder<(message: String, button: String?)> { get }
  var hasPreviousAddressFromIntegration: Bool { get }
  var orderListFirstRequest: Binder<Bool> { get }
  var orderList: Binder<[OrderListConfig]> { get }
  var newOrdersForList: Binder<Bool> { get }
  var noMoreOrderToLoad: Bool { get }
  var loadMoreError: Binder<String?> { get }
  var ordersInvoices: Binder<YDInvoices> { get }
  var invoiceDialog: Binder<URL?> { get }
  var quizEnabled: Bool { get set }
  
  subscript(_ item: Int) -> OrderListConfig? { get }
  
  func setNavigationController(_ navigation: UINavigationController?)
  func onBack()
  
  func login()
  func getMoreOrders()
  
  func openNote(withKey key: String?)
  func openDetailsForProduct(
    _ product: YDOfflineOrdersProduct,
    withinOrder order: YDOfflineOrdersOrder
  )
  func openDetailsForOrder(_ order: YDOfflineOrdersOrder)
  func onFeedbackButton()
  func getProductsForOrder(
    at index: Int,
    onCompletion completion: @escaping (Bool) -> Void
  )
  func openInvoice(for order: YDOfflineOrdersOrder)
  func checkIfCanShowInvoiceButton(for order: YDOfflineOrdersOrder) -> Bool
}

// MARK: Service Delegate aliases
typealias OfflineOrdersServiceDelegate =
  YDB2WServiceLasaClientDelegate &
  YDB2WServiceInvoiceDelegate &
  YDB2WServiceProductsDelegate

// MARK: ViewModel
class YDMOfflineOrdersViewModel {
  // MARK: Properties
  lazy var logger = YDUtilities.Logger.forClass(Self.self)
  let service: OfflineOrdersServiceDelegate
  let navigation: OfflineOrdersNavigationDelegate
  
  var hasPreviousAddressFromIntegration = YDIntegrationHelper.shared.currentAddres != nil
  
  var error: Binder<String> = Binder("")
  var errorDialog: Binder<(title: String?, message: String?)> = Binder((nil, nil))
  
  var loading: Binder<Bool> = Binder(false)
  var snackBar: Binder<(message: String, button: String?)> = Binder(("", nil))
  
  var ordersInvoices: Binder<YDInvoices> = Binder([])
  var invoiceDialog: Binder<URL?> = Binder(nil)
  
  var orderListFirstRequest: Binder<Bool> = Binder(false)
  var orderList: Binder<[OrderListConfig]> = Binder([])
  
  var newOrdersForList: Binder<Bool> = Binder(false)
  
  var loadMoreError: Binder<String?> = Binder(nil)
  var noMoreOrderToLoad = false
  let lazyLoadingOrders: Int
  var currentPage = 1
  
  let currentUser: YDCurrentCustomer
  var userToken = ""
  
  let ordersManager = YDManager.OfflineOrders.shared
  
  var quizEnabled = false
  
  private let errorDialogIncompletePerfilMessage = (
    title: "poooxa, ainda não temos seu cadastro completo",
    message: "E pra mantermos a segurança dos seus dados, você poderá consultar mais informações com nosso atendimento, através do e-mail: atendimento.acom@americanas.com"
  )
  
  private let errorDialogPerfilNotFoundMessage = (
    title: "poooxa, não encontramos os seus dados aqui",
    message: "Você pode consultar mais informações com nosso atendimento, através do e-mail: atendimento.acom@americanas.com"
  )
  
  // MARK: Inita
  init(
    navigation: OfflineOrdersNavigationDelegate,
    service: OfflineOrdersServiceDelegate = YDB2WService(),
    currentUser: YDCurrentCustomer,
    lazyLoadingOrders: Int
  ) {
    self.navigation = navigation
    self.service = service
    self.currentUser = currentUser
    self.lazyLoadingOrders = lazyLoadingOrders
    
    configureObservers()
    ordersManager.load(withId: currentUser.id)
    
    trackEvent(withName: .offlineOrders, ofType: .state)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

// MARK: Private
extension YDMOfflineOrdersViewModel {
  func trackEvent(
    withName name: TrackEvents,
    ofType type: TrackType,
    withParameters params: [String: Any]? = nil
  ) {
    YDIntegrationHelper.shared
      .trackEvent(
        withName: name,
        ofType: type,
        withParameters: params
      )
  }
  
  private func openDeepLink(withName name: YDDeepLinks) {
    guard let url = URL(string: name.rawValue),
          !url.absoluteString.isEmpty
    else { return }
    
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
  
  private func getInvoices() {
    service.getInvoicesLinks { [weak self] response in
      guard let self = self else { return }
      
      switch response {
        case .success(let invoices):
          self.ordersInvoices.value = invoices
          
        case .failure(let error):
          self.logger.error(error.message)
      }
    }
  }
  
  private func getInvoice(for order: YDOfflineOrdersOrder) -> YDInvoice? {
    guard let uf = order.addressState,
          let invoice = ordersInvoices.value.first(
            where: { $0.uf.lowercased() == uf.lowercased() }
          )
    else {
      return nil
    }
    
    return invoice
  }
  
  private func storeOrdersOnManager() {
    let orders = orderList.value.compactMap { $0.order }
    
    ordersManager.store(orders)
  }
  
  private func sortOrdersList(
    _ orders: [YDOfflineOrdersOrder]
  ) -> [YDOfflineOrdersOrder] {
    let sorted = orders.sorted { lhs, rhs -> Bool in
      guard let dateLhs = lhs.dateWithDateType else { return false }
      guard let dateRhs = rhs.dateWithDateType else { return true }
      
      return dateLhs.compare(dateRhs) == .orderedDescending
    }
    
    return sorted
  }
  
  private func addOrdersToList(_ sorted: [YDOfflineOrdersOrder], append: Bool) {
    if sorted.isEmpty {
      noMoreOrderToLoad = true
      newOrdersForList.value = false
      
      if !append {
        orderListFirstRequest.value = true
      }
    } else {
      for curr in sorted {
        guard let sectionDate = curr.formattedDateSection else { continue }
        
        if let lastIndex = orderList.value.lastIndex(
          where: { $0.type == .row && $0.headerString == sectionDate }
        ) {
          curr.indexPath = IndexPath(item: lastIndex + 1, section: 0)
          let newOrder = OrderListConfig(
            type: .row,
            headerString: sectionDate,
            order: curr
          )
          
          orderList.value.append(newOrder)
          
          //
        } else {
          let newHeader = OrderListConfig(
            type: .header,
            headerString: sectionDate,
            order: nil
          )
          orderList.value.append(newHeader)
          
          curr.indexPath = IndexPath(
            item: orderList.value.count,
            section: 0
          )
          
          let newOrder = OrderListConfig(
            type: .row,
            headerString: sectionDate,
            order: curr
          )
          
          orderList.value.append(newOrder)
        }
      }
      
      if append {
        newOrdersForList.value = true
      } else {
        orderListFirstRequest.value = true
      }
    }
  }
  
  private func onSuccessLogin(user: YDLasaClientLogin) {
    userToken = user.token ?? ""
    getInvoices()
    getOrderList()
    
    trackEvent(withName: .offlineOrdersSuccess, ofType: .state)
  }
  
  private func onSuccessGetOrders(
    orders: [YDOfflineOrdersOrder],
    adding: Bool,
    itsFromSavedOrders: Bool = false
  ) {
    let sorted = self.sortOrdersList(orders)
    addOrdersToList(sorted, append: adding)
    
    if itsFromSavedOrders { return }
    
    storeOrdersOnManager()
  }
  
  private func onErrorGetOrders(_ error: YDServiceError) {
    logger.error(error.message)
    loading.value = false
    
    switch error {
      case .noConnection, .timeout:
        let savedOrders = ordersManager.retrieve()
        
        onSuccessGetOrders(orders: savedOrders, adding: false, itsFromSavedOrders: true)
        
      default:
        errorDialog.value = errorDialogPerfilNotFoundMessage
    }
  }
}

// MARK: Observers
extension YDMOfflineOrdersViewModel {
  func configureObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(onQuizSuccess),
      name: YDConstants.Notification.QuizSuccess,
      object: nil
    )
  }
  
  @objc func onQuizSuccess() {
    login()
    snackBar.value = ("Seus dados foram atualizados com sucesso", nil)
  }
}

// MARK: Extension
extension YDMOfflineOrdersViewModel: YDMOfflineOrdersViewModelDelegate {
  subscript(_ item: Int) -> OrderListConfig? {
    return orderList.value.at(item)
  }
  
  func setNavigationController(_ navigation: UINavigationController?) {
    self.navigation.setNavigationController(navigation)
  }
  
  func onBack() {
    ordersManager.cleanUp()
    navigation.onBack()
  }
  
  func login() {
    loading.value = true
    
    // Mock
//     fromMock()
//     return;
    
    service.getLasaClientLogin(
      user: currentUser,
      socialSecurity: nil
    ) { [weak self] (response: Result<YDLasaClientLogin, YDServiceError>) in
      guard let self = self else { return }
      
      switch response {
        case .success(let userLoginData):
          self.onSuccessLogin(user: userLoginData)
          
        case .failure(let error):
          self.logger.error(error.message)
          self.loading.value = false
          
          if case .permanentRedirect = error {
            if self.quizEnabled {
              self.navigation.openQuiz()
            } else {
              self.errorDialog.value = self.errorDialogIncompletePerfilMessage
            }
            return
          }
          
          self.errorDialog.value = self.errorDialogPerfilNotFoundMessage
      }
    }
  }
  
  func getOrderList() {
    loading.value = true
    
    service.offlineOrdersGetOrders(
      userToken: userToken,
      page: currentPage,
      limit: lazyLoadingOrders
    ) { [weak self] (result: Result<YDOfflineOrdersOrdersList, YDB2WServices.YDServiceError>) in
      guard let self = self else { return }
      
      self.loading.value = false
      
      switch result {
        case .success(let orders):
          self.onSuccessGetOrders(orders: orders, adding: false)
          
        case .failure(let error):
          self.onErrorGetOrders(error)
      }
    }
  }
  
  func getMoreOrders() {
    currentPage += 1
    
    // From mock
    //    getMoreOrdersFromMock()
    //    return;
    
    service.offlineOrdersGetOrders(
      userToken: userToken,
      page: currentPage,
      limit: lazyLoadingOrders
    ) { [weak self] (result: Result<YDOfflineOrdersOrdersList, YDB2WServices.YDServiceError>) in
      guard let self = self else { return }
      
      switch result {
        case .success(let orders):
          self.onSuccessGetOrders(orders: orders, adding: true)
          
        case .failure(let error):
          self.logger.error(error.message)
          self.currentPage -= 1
          self.loadMoreError.value = "Ops! Falha ao carregar mais compras realizadas nas lojas físicas."
      }
    }
  }
  
  func openNote(withKey key: String?) {}
  
  func openDetailsForProduct(
    _ product: YDOfflineOrdersProduct,
    withinOrder order: YDOfflineOrdersOrder
  ) {
    // Mock unavailable online product
    // product.products?.online?.isAvailable = false
    
    if product.products?.online?.isAvailable == false {
      snackBar.value = ("Ops! O produto escolhido está indisponível no momento.", "ok, entendi")
      return
    }
    
    navigation.openDetailsForProduct(product, withinOrder: order)
  }
  
  func openDetailsForOrder(_ order: YDOfflineOrdersOrder) {
    let parameters = TrackEvents.offlineOrdersSuccess.parameters(body: [:])
    trackEvent(withName: .offlineOrdersSuccess, ofType: .action, withParameters: parameters)
    
    navigation.openDetailsForOrder(order, ordersInvoices: ordersInvoices.value)
  }
  
  func onFeedbackButton() {
    if hasPreviousAddressFromIntegration {
      openDeepLink(withName: .lasaStore)
    } else {
      YDMFindStore().start()
    }
  }
  
  func getProductsForOrder(
    at index: Int,
    onCompletion completion: @escaping (Bool) -> Void
  ) {
    guard let order = orderList.value.at(index)?.order,
          order.alreadySearchOnAPI == false,
          let products = order.products,
          let storeId = order.storeId
    else {
      completion(false)
      return
    }
    
    orderList.value[index].order?.alreadySearchOnAPI = true
    
    let eans = Array(products.map { $0.ean }.compactMap { $0 }.prefix(3))
    
    service.getProductsFromRESQL(
      eans: eans,
      storeId: "\(storeId)"
    ) { [weak self] (response: Result<YDProductsRESQL, YDB2WServices.YDServiceError>) in
      guard let self = self else { return }
      
      switch response {
        case .success(let restql):
          restql.products.enumerated().forEach { productsIndex, onlineOffline in
            if self.orderList.value.at(index) != nil {
              self.orderList.value[index].order?
                .products?[productsIndex].products = onlineOffline
              
              guard let totalPrice = self.orderList.value.at(index)?
                      .order?.products?[productsIndex].totalPrice,
                    let howMany = self.orderList.value.at(index)?
                      .order?.products?[productsIndex].howMany
              else { return }
              
              self.orderList.value[index].order?
                .products?[productsIndex].products?
                .offline?.price = howMany == 1 ?
                totalPrice : (totalPrice / Double(howMany))
            }
          }
          completion(true)
          
        case .failure:
          completion(true)
      }
    }
  }
  
  func checkIfCanShowInvoiceButton(for order: YDOfflineOrdersOrder) -> Bool {
    guard let invoice = getInvoice(for: order) else { return false }
    return invoice.canOpen
  }
  
  func openInvoice(for order: YDOfflineOrdersOrder) {
    guard let invoice = getInvoice(for: order),
          let nfe = order.strippedNFe
    else {
      return
    }
    
    if invoice.canOpen {
      invoiceDialog.value = invoice.getUrl(withCode: nfe)
    }
  }
}

// MARK: Mock
extension YDMOfflineOrdersViewModel {
  private func fromMock() {
    Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] _ in
      guard let self = self else { return }
      let orders = YDOfflineOrdersOrder.mock()
      //      let sorted = self.sortOrdersList([])
      let sorted = self.sortOrdersList(orders)
      self.addOrdersToList(sorted, append: false)
      self.loading.value = false
      //      self.error.value = "a"
    }
  }
}
