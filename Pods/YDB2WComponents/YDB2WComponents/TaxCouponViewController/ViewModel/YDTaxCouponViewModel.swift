//
//  YDTaxCouponViewModel.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 25/08/21.
//

import Foundation
import YDUtilities
import YDB2WModels

public protocol YDTaxCouponNavigationDelegate: AnyObject {
  func onTaxCouponExit()
}

protocol YDTaxCouponViewModelDelegate: AnyObject {
  var products: [YDOfflineOrdersProduct] { get }
  
  func getOrderDetails() -> YDOfflineOrdersOrder
  func onExit()
}

class YDTaxCouponViewModel {
  // MARK: Properties
  let navigation: YDTaxCouponNavigationDelegate
  let order: YDOfflineOrdersOrder
  var products: [YDOfflineOrdersProduct]
  
  // MARK: Init
  init(navigation: YDTaxCouponNavigationDelegate, order: YDOfflineOrdersOrder) {
    self.navigation = navigation
    
    self.order = order
    self.products = order.products ?? []
  }
}

// MARK: Extension
extension YDTaxCouponViewModel: YDTaxCouponViewModelDelegate {
  func onExit() {
    navigation.onTaxCouponExit()
  }
  
  func getOrderDetails() -> YDOfflineOrdersOrder { self.order }
}
