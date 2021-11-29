//
//  OrderDetailsViewModel.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 12/03/21.
//

import Foundation
import YDB2WIntegration
import YDB2WServices
import YDExtensions
import YDB2WModels
import YDUtilities
import YDB2WComponents

// MARK: Details navigation
protocol OrderDetailsNavigation {
  func onBack()
  func openDetailsForProduct(
    _ product: YDOfflineOrdersProduct,
    withinOrder order: YDOfflineOrdersOrder
  )
  func openTaxCoupon(from order: YDOfflineOrdersOrder)
  func openNPSView(for order: YDOfflineOrdersOrder)
}

// MARK: Details Delegate
protocol OrderDetailsViewModelDelegate: AnyObject {
  var order: Binder<YDOfflineOrdersOrder> { get }
  var ordersInvoices: YDInvoices { get }
  var invoiceDialog: Binder<URL?> { get }
  
  var snackBar: Binder<(message: String, button: String?)> { get }
  
  var npsDaysToStillShow: Int { get set }
  var showNPSViewWithRemainingDays: Binder<Int?> { get }

  func goBack()
  func checkIfNeedToShowNPSView()
  func openDetailsForProduct(_ product: YDOfflineOrdersProduct)
  func getProducts()
  func openInvoice()
  func openTaxCoupon()
  func openDescriptionDialog()
  func openNPSView()
}

class OrderDetailsViewModel {
  // MARK: Properties
  let service: YDB2WServiceDelegate
  let navigation: OrderDetailsNavigation

  var order: Binder<YDOfflineOrdersOrder>
  var ordersInvoices: YDInvoices
  var invoiceDialog: Binder<URL?> = Binder(nil)
  
  var snackBar: Binder<(message: String, button: String?)> = Binder(("", nil))
  
  var npsDaysToStillShow = 7
  var showNPSViewWithRemainingDays: Binder<Int?> = Binder(nil)
  
  var npsCardViewEnabled = false

  // MARK: Init
  init(
    service: YDB2WServiceDelegate = YDB2WService(),
    navigation: OrderDetailsNavigation,
    order: YDOfflineOrdersOrder,
    ordersInvoices: YDInvoices
  ) {
    self.service = service
    self.navigation = navigation
    self.order = Binder(order)
    self.ordersInvoices = ordersInvoices
    
    configureObservers()
    trackEvent(.offlineOrdersOrderDetails, ofType: .state)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

// MARK: Actions
extension OrderDetailsViewModel {
  private func trackEvent(
    _ name: TrackEvents,
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
  
  private func useOfflineProducts() {
    guard let products = order.value.products else {
      return
    }

    for product in products {
      if product.products != nil { continue }

      let productForOnlineOffline = YDProduct(
        attributes: nil,
        description: nil,
        id: nil,
        ean: product.ean,
        images: nil,
        name: product.name,
        price: product.howMany == 1 ?
          product.totalPrice :
          (product.totalPrice / Double(product.howMany)),
        rating: nil,
        isAvailable: false
      )

      product.products = YDProductOnlineOffline(
        online: nil,
        offline: productForOnlineOffline
      )
    }

    self.order.fire()
  }
  
  private func getInvoice() -> YDInvoice? {
    guard let uf = order.value.addressState,
          let invoice = ordersInvoices.first(
            where: { $0.uf.lowercased() == uf.lowercased() }
          )
    else {
      return nil
    }
    
    return invoice
  }
  
  private func onGetProductsSuccess(interface: YDProductsRESQL) {
    interface.products.enumerated().forEach { productsIndex, onlineOffline in
      if order.value.products?.at(productsIndex) != nil {
        order.value.products?[productsIndex].products = onlineOffline

        guard let totalPrice = order.value.products?[productsIndex].totalPrice,
              let howMany = order.value.products?[productsIndex].howMany
        else { return }

        order.value.products?[productsIndex].products?.offline?.price = howMany == 1 ?
          totalPrice :
          (totalPrice / Double(howMany))
      }
    }
    
    order.fire()
  }
}

// MARK: Extends Delegate
extension OrderDetailsViewModel: OrderDetailsViewModelDelegate {
  func goBack() {
    navigation.onBack()
  }
  
  func getProducts() {
    guard let products = order.value.products,
          let storeId = order.value.storeId
    else { return }

    let eans = products.compactMap { $0.ean }

    service.getProductsFromRESQL(
      eans: eans,
      storeId: "\(storeId)"
    ) { [weak self] (response: Result<YDProductsRESQL, YDB2WServices.YDServiceError>) in
      guard let self = self else { return }

      switch response {
        case .success(let restql):
          self.onGetProductsSuccess(interface: restql)

        case .failure(let error):
          print(error.message)
          self.useOfflineProducts()
      }
    }
  }

  func openDetailsForProduct(_ product: YDOfflineOrdersProduct) {
//    product.products?.online?.isAvailable = false

    if product.products?.online?.isAvailable == false {
      snackBar.value = ("Ops! O produto escolhido está indisponível no momento.", "ok, entendi")
      return
    }
    
    let parameters = TrackEvents.offlineOrdersOrderDetails.parameters(
      body: ["action": "clique no produto"]
    )
    trackEvent(.offlineOrdersOrderDetails, ofType: .action, withParameters: parameters)

    navigation.openDetailsForProduct(product, withinOrder: order.value)
  }
  
  func openInvoice() {
    guard let invoice = getInvoice(),
          let nfe = order.value.strippedNFe
    else {
      return
    }

    if invoice.canOpen {
      invoiceDialog.value = invoice.getUrl(withCode: nfe)
    }
    
    let parameters = TrackEvents.offlineOrdersOrderDetails.parameters(body: ["action": "nota fiscal"])
    trackEvent(.offlineOrdersOrderDetails, ofType: .action, withParameters: parameters)
  }
  
  func openTaxCoupon() {
    let parameters = TrackEvents.offlineOrdersOrderDetails.parameters(
      body: ["action": "cupom fiscal"]
    )
    trackEvent(.offlineOrdersOrderDetails, ofType: .action, withParameters: parameters)
    
    navigation.openTaxCoupon(from: order.value)
  }
  
  func openDescriptionDialog() {
    let title = "o que é cada um desses documentos?"
    let message = """
    Cupom fiscal: é um comprovante de venda e pode ser utilizado para realizar trocas dentro das lojas, ele é auxiliar da nota fiscal.

    Nota fiscal: é um documento oficial que pode ser utilizado para trocas com o fabricante, fazer seguros e usar para assistência técnica.
    """
    
    YDDialog().start(
      ofType: .simple,
      customTitle: title,
      customMessage: message,
      messagesToBold: ["Cupom fiscal:", "Nota fiscal:"]
    )
    
    let parameters = TrackEvents.offlineOrdersOrderDetails.parameters(
      body: ["action": "entenda as diferenças"]
    )
    
    trackEvent(.offlineOrdersOrderDetails, ofType: .action, withParameters: parameters)
  }
  
  func checkIfNeedToShowNPSView() {
    let today = Date()
    
    guard npsCardViewEnabled,
          let orderId = order.value.cupom,
          !YDManager.OfflineOrders.shared.alreadyRepliedNPS(for: "\(orderId)"),
          let orderDate = order.value.dateWithDateType,
          let deadline = Calendar.current.date(
            byAdding: .day,
            value: npsDaysToStillShow,
            to: orderDate
          ),
          today.isBetween(orderDate, and: deadline),
          let remainingDays = Calendar.current.dateComponents([.day], from: today, to: deadline).day
    else {
      showNPSViewWithRemainingDays.value = nil
      return
    }
    
//    print("already replied", YDManager.OfflineOrders.shared.alreadyRepliedNPS(for: "\(order.value.cupom!)"))
    
//    let remainingDays = 0
    
    trackEvent(.offlineOrdersNPS, ofType: .state)
    
    showNPSViewWithRemainingDays.value = remainingDays
  }
  
  func openNPSView() {
    let metricParameters = TrackEvents.offlineOrdersNPS.parameters(body: [:])
    trackEvent(.offlineOrdersNPS, ofType: .action, withParameters: metricParameters)
    
    navigation.openNPSView(for: order.value)
  }
}
