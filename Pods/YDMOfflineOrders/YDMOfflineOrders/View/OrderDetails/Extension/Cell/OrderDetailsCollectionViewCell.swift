//
//  OrderDetailsCollectionViewCell.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 12/03/21.
//

import UIKit

import YDB2WModels

class OrderDetailsCollectionViewCell: UICollectionViewCell {
  // MARK: Properties
  var productView = OrderDetailsProductView()

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)

    setUpLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    productView.prepareForUse()
    super.prepareForReuse()
  }

  // MARK: Actions
  func config(with product: YDOfflineOrdersProduct) {
    productView.config(with: product)
  }
}

// MARK: Layout
extension OrderDetailsCollectionViewCell {
  func setUpLayout() {
    contentView.addSubview(productView)
    productView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      productView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      productView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      productView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    ])
  }
}
