//
//  OrderDetailsViewController.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 12/03/21.
//

import UIKit
import YDB2WComponents

class OrderDetailsViewController: UIViewController {
  // MARK: Properties
  var viewModel: OrderDetailsViewModelDelegate?
  var orderNoteButtonEnabled = false
  var navBarShadowOff = false
  let padding: CGFloat = 16

  // MARK: Components
  let storeNameAndAddress = StoreNameAndAddressView()
  var storeAndAddressSeparatorView = UIView()
  
  let NPSView = NPSCallView()
  var NPSViewSeparatorView = UIView()
  
  let dateAndDescriptionContainer = UIView()
  let dateLabel = UILabel()
  let descriptionButton = UIButton()
  
  let taxCouponAndInvoiceContainer = UIView()
  
  let taxCouponButton = YDWireButton(withTitle: "ver cupom fiscal")
  lazy var taxCouponFullTrailingConstraint: NSLayoutConstraint = {
    taxCouponButton.trailingAnchor.constraint(
      equalTo: taxCouponAndInvoiceContainer.trailingAnchor,
      constant: -padding
    )
  }()
  lazy var taxCouponTrailingConstraint: NSLayoutConstraint = {
    let trailing = NSLayoutConstraint(
      item: taxCouponButton,
      attribute: .trailing,
      relatedBy: .equal,
      toItem: taxCouponAndInvoiceContainer,
      attribute: .centerX,
      multiplier: 0.9,
      constant: 10
    )
    return trailing
  }()
  
  let noteButton = YDWireButton(withTitle: "ver nota fiscal")
  lazy var noteButtonLeadingConstraint: NSLayoutConstraint = {
    let trailing = NSLayoutConstraint(
      item: noteButton,
      attribute: .leading,
      relatedBy: .equal,
      toItem: taxCouponAndInvoiceContainer,
      attribute: .centerX,
      multiplier: 1,
      constant: 10
    )
    return trailing
  }()
  
  var separatorBottomTaxCouponContainerView = UIView()
  
  var collectionView: UICollectionView!
  var shadowTop = UIView()
  var shadowBottom = UIView()
  
  let priceContainer = UIView()
  let totalProductsLabel = UILabel()
  let priceLabel = UILabel()

  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpLayout()
    setUpBinds()
    bindOrderData()
    // viewModel?.getProducts()
    viewModel?.checkIfNeedToShowNPSView()
  }

  // MARK: Actions
  private func bindOrderData() {
    guard let order = viewModel?.order.value else { return }
    
    storeNameAndAddress.configure(with: order)
    dateLabel.text = order.formattedDate
    priceLabel.text = order.formattedPrice
    totalProductsLabel.text = "total de produtos: \(order.products?.count ?? 1)"
    
    NPSView.configure(remainingDays: 1)
  }
  
  @objc func onBackAction(_ sender: UIButton) {
    viewModel?.goBack()
  }
  
  func onNPSViewTapAction() {
    viewModel?.openNPSView()
  }

  @objc func onNoteAction(_ sender: UIButton) {
    viewModel?.openInvoice()
  }
  
  @objc func onTaxCouponAction(_ sender: UIButton) {
    viewModel?.openTaxCoupon()
  }
  
  @objc func onDescriptionAction() {
    viewModel?.openDescriptionDialog()
  }

  func toggleNavShadow(_ show: Bool) {
    DispatchQueue.main.async {
      if show {
        UIView.animate(withDuration: 0.5) { [weak self] in
          guard let self = self else { return }
          self.shadowTop.layer.applyShadow()
          self.separatorBottomTaxCouponContainerView.isHidden = true
        }
      } else {
        UIView.animate(withDuration: 0.5) { [weak self] in
          guard let self = self else { return }
          self.shadowTop.layer.shadowOpacity = 0
          self.separatorBottomTaxCouponContainerView.isHidden = false
        }
      }
    }
  }
}
