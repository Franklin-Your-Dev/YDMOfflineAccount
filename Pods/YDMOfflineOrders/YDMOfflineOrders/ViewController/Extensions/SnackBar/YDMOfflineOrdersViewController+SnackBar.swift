//
//  YDMOfflineOrdersViewController+SnackBar.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 20/04/21.
//

import UIKit

import YDB2WComponents

// MARK: YDSnackBarDelegate
extension YDMOfflineOrdersViewController: YDSnackBarDelegate {
  public func onSnackAction() {
    viewModel?.getMoreOrders()
  }
}
