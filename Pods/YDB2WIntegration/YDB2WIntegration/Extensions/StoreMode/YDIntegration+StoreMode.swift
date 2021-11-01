//
//  YDIntegration+StoreMode.swift
//  YDB2WIntegration
//
//  Created by Douglas Hennrich on 08/12/20.
//

import UIKit

// MARK: Open store module
public extension YDIntegrationHelper {
  func openStoreMode(deeplink: String?) {
    presentationDelegate?.presentStoreMode(deeplink: deeplink)
  }
}

// MARK: On product discount
public extension YDIntegrationHelper {
  func activateDiscount(offerId: String, completion: ((Bool) -> Void)?) {
    actionDelegate?.activateDiscount(offerId: offerId, completion: completion)
  }
}

// MARK: Open Offline Orders
public extension YDIntegrationHelper {
  func openOfflineOrders(navigationController: UINavigationController? = nil) {
    presentationDelegate?.presentOfflineOrders(navigationController: navigationController)
  }
}
