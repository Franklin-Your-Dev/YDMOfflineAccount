//
//  OrdersCollectionViewCell.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 09/03/21.
//
import UIKit

import YDExtensions
import YDB2WAssets
import YDB2WModels
import YDUtilities

class OrdersCollectionViewCell: UICollectionViewCell {
  // MARK: Components
  lazy var width: NSLayoutConstraint = {
    let width = contentView.widthAnchor
      .constraint(equalToConstant: bounds.size.width)
    width.isActive = true
    return width
  }()
  let orderView = OrderView()

  // MARK: Properties
  var productCallback: ((YDOfflineOrdersProduct) -> Void)? {
    didSet {
      orderView.productCallback = productCallback
    }
  }
  var orderDetailsCallback: (() -> Void)? {
    didSet {
      orderView.orderDetailsCallback = orderDetailsCallback
    }
  }
  var noteCallback: (() -> Void)? {
    didSet {
      orderView.noteCallback = noteCallback
    }
  }

  // Init
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    setUpLayout()
  }

  override func systemLayoutSizeFitting(
    _ targetSize: CGSize,
    withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
    verticalFittingPriority: UILayoutPriority
  ) -> CGSize {
    width.constant = bounds.size.width
    return contentView.systemLayoutSizeFitting(
      CGSize(width: targetSize.width, height: 1)
    )
  }

  override func prepareForReuse() {
    productCallback = nil
    orderDetailsCallback = nil
    noteCallback = nil
    orderView.reset()
    super.prepareForReuse()
  }

  // Actions
  func config(with order: YDOfflineOrdersOrder) {
    orderView.config(with: order)
  }
  
  func config(shimmer: Bool = true) {
    orderView.config()
  }
  
  @objc func onOrderDetailsAction() {
    orderDetailsCallback?()
  }
}

// MARK: Layout
extension OrdersCollectionViewCell {
  func setUpLayout() {
    configureOrderView()
  }

  func configureOrderView() {
    contentView.addSubview(orderView)
    
    NSLayoutConstraint.activate([
      orderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
      orderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
      orderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
      orderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1)
    ])
  }
}
