//
//  ProductDetailsViewController+Binds.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 26/03/21.
//

import UIKit

extension ProductDetailsViewController {
  func setUpBinds() {
    viewModel?.loading.bind { [weak self] isLoading in
      guard let self = self else { return }
      self.stateView = isLoading ? .loading : .normal
    }

    viewModel?.currentProductOnlineOffline.bind { [weak self] newProducts in
      guard let self = self else { return }
      self.productOnlineOffline = newProducts
    }

    viewModel?.currentStore.bind { [weak self] newStore in
      guard let self = self else { return }
      self.store = newStore
    }

    viewModel?.error.bind { [weak self] _ in
      guard let self = self else { return }
      self.stateView = .error
    }
  }
}
