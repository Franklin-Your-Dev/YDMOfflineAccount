//
//  YDMOfflineOrdersCoordinator.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 21/02/21.
//

import UIKit

import YDB2WIntegration
import YDB2WModels
import YDQuiz
import YDB2WComponents
import YDUtilities

public typealias YDMOfflineOrders = YDMOfflineOrdersCoordinator

public class YDMOfflineOrdersCoordinator {
  // MARK: Properties
  private var navigationController: UINavigationController?
  private var currentUser: YDCurrentCustomer?
  
  private var ordersViewModel: YDMOfflineOrdersViewModelDelegate?
  
  private var lazyLoadingOrders: Int = 5
  private var orderNoteButtonEnabled = false
  private var orderDetailsNPSCardViewEnabled = false
  
  private var quizEnabled = false

  // MARK: Init
  public init() {
    if let limit = YDIntegrationHelper.shared
        .getFeature(featureName: YDConfigKeys.lasaClientService.rawValue)?
        .extras?[YDConfigProperty.lazyLoadingOrders.rawValue] as? Int {
      self.lazyLoadingOrders = limit
    }

    if let orderNoteButtonEnabled = YDIntegrationHelper.shared
        .getFeature(featureName: YDConfigKeys.store.rawValue)?
        .extras?[YDConfigProperty.offlineOrdersNoteEnabled.rawValue] as? Bool {
      self.orderNoteButtonEnabled = orderNoteButtonEnabled
    }
    
    if let orderNPSEnabled = YDIntegrationHelper.shared
        .getFeature(featureName: YDConfigKeys.store.rawValue)?
        .extras?[YDConfigProperty.offlineOrdersNPSEnabled.rawValue] as? Bool {
      self.orderDetailsNPSCardViewEnabled = orderNPSEnabled
    }
    
    if let quizEnabled = YDIntegrationHelper.shared
        .getFeature(featureName: YDConfigKeys.store.rawValue)?
        .extras?[YDConfigProperty.quizEnabled.rawValue] as? Bool {
      self.quizEnabled = quizEnabled
    }
  }

  public func start(navController: UINavigationController?) {
    getCurrentUser { [weak self] currentUser in
      guard let self = self else { return }
      guard let user = currentUser else {
        print("@@@@@@ ERRO", #function, "Não foi possível encontrar um usuário logado")
        return
      }
      
      self.currentUser = user
      
      let vc = YDMOfflineOrdersViewController()
      self.ordersViewModel = YDMOfflineOrdersViewModel(
        navigation: self,
        currentUser: user,
        lazyLoadingOrders: self.lazyLoadingOrders
      )
      self.ordersViewModel?.quizEnabled = self.quizEnabled
      
      vc.viewModel = self.ordersViewModel
      vc.orderNoteButtonEnabled = self.orderNoteButtonEnabled

      navController?.pushViewController(vc, animated: true)
      self.navigationController = navController
    }
  }

  // MARK: Actions
  private func getCurrentUser(onCompletion completion: @escaping(YDCurrentCustomer?) -> Void) {
    YDIntegrationHelper.shared.getCustomer { currentUser in
      guard let user = currentUser else {
        self.getCurrentUserFromLogin(onCompletion: completion)
        return
      }
      
      completion(user)
    }
  }
  
  private func getCurrentUserFromLogin(onCompletion completion: @escaping(YDCurrentCustomer?) -> Void) {
    YDIntegrationHelper.shared.makeLogin { currentUser in
      guard let user = currentUser else {
        completion(nil)
        return
      }
      
      completion(user)
    }
  }
  
  func onExit(onCompletion completion: (() -> Void)? = nil) {
    navigationController?.dismiss(animated: true, completion: completion)
  }
  
  func onBack() {
    if navigationController?.viewControllers.count == 1 {
      onExit()
    } else {
      navigationController?.popViewController(animated: true)
    }
  }

  func openDetailsForProduct(
    _ product: YDOfflineOrdersProduct,
    withinOrder order: YDOfflineOrdersOrder
  ) {
    let vc = ProductDetailsViewController()
    
    let offlineProduct = YDProduct(
      attributes: nil,
      description: nil,
      id: nil,
      ean: product.ean,
      images: nil,
      name: product.originalName,
      price: product.totalPrice,
      rating: nil,
      isAvailable: true
    )
    
    let products = YDProductOnlineOffline(
      online: nil,
      offline: offlineProduct
    )

    let viewModel = ProductDetailsViewModel(product: products, order: order)
    vc.viewModel = viewModel

    navigationController?.pushViewController(vc, animated: true)
  }
  
  public static func createTaxCouponViewController(
    from order: YDOfflineOrdersOrder
  ) -> YDTaxCouponContainerViewController {
    var taxCouponShareEnabled = false
    
    if let taxCouponShareEnabledFromConfig = YDIntegrationHelper.shared
        .getFeature(featureName: YDConfigKeys.store.rawValue)?
        .extras?[YDConfigProperty.taxCouponShareEnabled.rawValue] as? Bool {
      taxCouponShareEnabled = taxCouponShareEnabledFromConfig
    }
    
    let vc = YDTaxCouponContainerViewController(
      order: order,
      taxCouponShareEnabled: taxCouponShareEnabled
    )
    vc.modalPresentationStyle = .overFullScreen
    vc.modalTransitionStyle = .crossDissolve
    
    return vc
  }
}

// MARK: Orders Navigation
extension YDMOfflineOrdersCoordinator: OfflineOrdersNavigationDelegate {
  func setNavigationController(_ navigation: UINavigationController?) {
    self.navigationController = navigation
  }

  func openDetailsForOrder(_ order: YDOfflineOrdersOrder, ordersInvoices: YDInvoices) {
    let vc = OrderDetailsViewController()
    let viewModel = OrderDetailsViewModel(
      navigation: self,
      order: order,
      ordersInvoices: ordersInvoices
    )
    viewModel.npsCardViewEnabled = orderDetailsNPSCardViewEnabled
    
    vc.viewModel = viewModel
    vc.orderNoteButtonEnabled = orderNoteButtonEnabled

    navigationController?.pushViewController(vc, animated: true)
  }
  
  func openQuiz() {
    guard let user = currentUser else {
      print("@@@@@@ ERRO", #function, "Não foi possível encontrar um usuário logado")
      return
    }
    
    YDQuiz().start(user: user)
  }
}

// MARK: Order Details Navigation
extension YDMOfflineOrdersCoordinator: OrderDetailsNavigation {
  func openTaxCoupon(from order: YDOfflineOrdersOrder) {
    let vc = YDMOfflineOrders.createTaxCouponViewController(from: order)
    
    navigationController?.present(vc, animated: true)
  }
  
  func openNPSView(for order: YDOfflineOrdersOrder) {
    guard let npsSpaceyId = YDIntegrationHelper.shared
            .getFeature(featureName: YDConfigKeys.store.rawValue)?
            .extras?[YDConfigProperty.npsSpaceyId.rawValue] as? String,
          let orderId = order.cupom,
          let storeId = order.storeId
    else {
      print("@@@@ ERRO", #function)
      return
    }
    
    let spaceyViewModel = YDSpaceyViewModel(supportedTypes: nil, supportedNPSAnswersTypes: nil)
    spaceyViewModel.spaceyId = npsSpaceyId
    
    let viewModel = NPSViewModel(
      navigation: self,
      spaceyViewModel: spaceyViewModel,
      storeId: "\(storeId)",
      orderId: "\(orderId)"
    )
    let vc = NPSViewController()
    vc.viewModel = viewModel
    
    navigationController?.pushViewController(vc, animated: true)
  }
}

// MARK: NPS Navigation
extension YDMOfflineOrdersCoordinator: NPSNavigation {
  func onNPSSent(snackBarMessage: String?) {
    onBack()
    NotificationCenter.default.post(
      name: YDConstants.Notification.NPSSent,
      object: nil,
      userInfo: ["message": snackBarMessage ?? ""]
    )
  }
}
