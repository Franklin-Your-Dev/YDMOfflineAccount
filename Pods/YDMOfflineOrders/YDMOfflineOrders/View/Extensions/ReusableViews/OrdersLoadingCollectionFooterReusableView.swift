//
//  OrdersLoadingCollectionHeaderReusableView.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 23/03/21.
//

import UIKit

import YDExtensions

class OrdersLoadingCollectionFooterReusableView: UICollectionReusableView {
  // MARK: Properties
  var componentHidden = false

  // MARK: Components
  lazy var width: NSLayoutConstraint = {
    let width = widthAnchor
      .constraint(equalToConstant: bounds.size.width)
    width.isActive = true
    return width
  }()
  lazy var heightConstraint: NSLayoutConstraint = {
    heightAnchor.constraint(equalToConstant: 20)
  }()
  let orderView = OrderView()

  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(orderView)
    
    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      orderView.topAnchor.constraint(equalTo: topAnchor, constant: 1),
      orderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
      orderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
      orderView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1)
    ])

    orderView.config()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func systemLayoutSizeFitting(
    _ targetSize: CGSize,
    withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
    verticalFittingPriority: UILayoutPriority
  ) -> CGSize {
    width.constant = bounds.size.width
    return systemLayoutSizeFitting(
      CGSize(width: targetSize.width, height: 1)
    )
  }

  // MARK: Actions
  func stopShimmerAndHide() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      
      self.heightConstraint.isActive = true
      self.orderView.stateView = .normal
      self.orderView.isHidden = true
      self.componentHidden = true
    }
  }
}
