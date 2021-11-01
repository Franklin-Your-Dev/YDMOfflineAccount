//
//  YDIntegration+Live.swift
//  YDB2WIntegration
//
//  Created by Douglas Hennrich on 08/12/20.
//

import UIKit

// MARK: Open live module
public extension YDIntegrationHelper {
  func openLive(navigationController: UINavigationController?, deepLink: String?) {
    presentationDelegate?.presentLive(
      navigationController: navigationController,
      deepLink: deepLink
    )
  }
}

// MARK: Add to cart
public extension YDIntegrationHelper {
  func addProductToCart(parameters: [String: Any]?) {
    actionDelegate?.addProductToCart(parameters: parameters)
  }
}
