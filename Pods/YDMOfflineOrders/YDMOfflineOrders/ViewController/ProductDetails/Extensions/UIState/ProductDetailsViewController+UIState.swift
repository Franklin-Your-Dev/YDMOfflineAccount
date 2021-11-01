//
//  ProductDetailsViewController+UIState.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 08/04/21.
//

import UIKit

import YDUtilities

extension ProductDetailsViewController: YDUIStateDelegate {
  func changeUIState(with type: YDUIStateEnum) {
    switch type {
      case .normal:
        canShowOnlineProduct = true
        storeAndProductView.stateView = .normal
        onlineProductView.stateView = .normal

      case .loading:
        storeAndProductView.stateView = .loading
        onlineProductView.stateView = .loading
        
      case .error:
        canShowOnlineProduct = false
        compareProductViewVisibility(show: false)
        storeAndProductView.stateView = .error

      default:
        break
    }
  }
}
