//
//  ProductDetailsViewController.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 26/02/21.
//

import UIKit
import YDUtilities
import YDB2WComponents
import YDB2WModels

class ProductDetailsViewController: UIViewController {
  // MARK: Properties
  var stateView: YDUIStateEnum = .normal {
    didSet {
      changeUIState(with: stateView)
    }
  }
  var viewModel: ProductDetailsViewModelDelegate?
  var productOnlineOffline: YDProductOnlineOffline? {
    didSet {
      updateLayoutWithOfflineProduct()
      updateLayoutWithOnlineProduct()
    }
  }
  var store: YDStore? {
    didSet {
      updateLayoutWithStore()
    }
  }
  
  var canShowOnlineProduct = true

  // MARK: Components
  let storeAndProductView = YDStoreAndProductView()
  let compareProductsView = UIView()
  lazy var compareProductsBottomConstraint: NSLayoutConstraint = {
    return compareProductsView.bottomAnchor
      .constraint(equalTo: view.bottomAnchor)
  }()
  let compareProductsViewShadow = UIView()
  let onlineProductView = YDProductCardView(fromOnline: true)

  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpLayout()
    setUpBinds()

//    bindCurrentProductAndStore()
    store = viewModel?.currentStore.value
    productOnlineOffline = viewModel?.currentProductOnlineOffline.value
    
    viewModel?.getProductFromService()

    storeAndProductView.errorStateActionCallback = { [weak self] _ in
      guard let self = self else { return }
      self.viewModel?.changeAddress()
    }

    onlineProductView.addGestureRecognizer(
      UITapGestureRecognizer(target: self, action: #selector(onOnlineProductViewTap))
    )
  }
}

// MARK: Actions
extension ProductDetailsViewController {
  private func updateLayoutWithOfflineProduct() {
    guard let product = productOnlineOffline?.offline,
          product.isAvailable else {
      storeAndProductView.changeUIState(with: .empty)
      return
    }

    storeAndProductView.product = product
  }

  private func updateLayoutWithOnlineProduct() {
    guard let product = productOnlineOffline?.online else {
      compareProductViewVisibility(show: false)
      return
    }

    compareProductViewVisibility(show: true)
    onlineProductView.product = product
  }

  private func updateLayoutWithStore() {
    guard let store = store else { return }
    storeAndProductView.store = store
  }

  func compareProductViewVisibility(show: Bool) {
    let heighSize: CGFloat = (
      UIDevice.hasNotch ?
        184 :
        154
    ) + view.safeAreaInsets.bottom

    guard canShowOnlineProduct else {
      compareProductsBottomConstraint.constant = heighSize
      UIView.animate(withDuration: 0.3) {
        self.view.layoutIfNeeded()
      }
      return
    }
    
    compareProductsBottomConstraint.constant = show ? 0 : heighSize
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }

//  func bindCurrentProductAndStore() {
//    guard let viewModel = viewModel,
//          let products = viewModel.currentProductOnlineOffline.value,
//          let store = viewModel.currentStore.value
//    else { return }
//
//    productOnlineOffline = products
//    self.store = store
//  }

  @objc func onOnlineProductViewTap() {
    viewModel?.openOnlineProduct()
  }
}
