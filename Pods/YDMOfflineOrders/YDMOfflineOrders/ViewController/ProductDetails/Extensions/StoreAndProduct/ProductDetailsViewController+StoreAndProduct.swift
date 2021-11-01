//
//  ProductDetailsViewController+StoreAndProduct.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 26/03/21.
//

import Foundation

import YDB2WComponents

// MARK: YDStoreAndProductDelegate
extension ProductDetailsViewController: YDStoreAndProductDelegate {
  func onChangeStoreAction() {
    viewModel?.changeAddress()
  }

  func didMove(direction: YDStoreAndProductView.ScrollDirection) {
    compareProductViewVisibility(show: direction == .down)
  }
}
