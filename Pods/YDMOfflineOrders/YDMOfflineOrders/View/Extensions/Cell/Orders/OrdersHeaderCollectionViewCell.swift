//
//  OrdersHeaderCollectionViewCell.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 30/03/21.
//

import UIKit
import YDB2WColors

class OrdersHeaderCollectionViewCell: UICollectionViewCell {
  // MARK: Components
  lazy var width: NSLayoutConstraint = {
    let width = contentView.widthAnchor
      .constraint(equalToConstant: bounds.size.width)
    width.isActive = true
    return width
  }()
  let dateContainer = UIView()
  let dateLabel = UILabel()

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.translatesAutoresizingMaskIntoConstraints = false
    setUpLayout()
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
    return contentView.systemLayoutSizeFitting(
      CGSize(width: targetSize.width, height: 1)
    )
  }
}

// MARK: Layout
extension OrdersHeaderCollectionViewCell {
  func setUpLayout() {
    dateContainer.backgroundColor = YDColors.white
    dateContainer.layer.cornerRadius = 10
    dateContainer.layer.applyShadow(alpha: 0.15, x: 0, y: 0, blur: 20)
    contentView.addSubview(dateContainer)

    dateContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateContainer.heightAnchor.constraint(equalToConstant: 20),
      dateContainer.topAnchor
        .constraint(equalTo: contentView.topAnchor, constant: 30),
      dateContainer.bottomAnchor
        .constraint(equalTo: contentView.bottomAnchor, constant: -8),
      dateContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
    ])

    dateLabel.font = .systemFont(ofSize: 12)
    dateLabel.textColor = YDColors.Gray.light
    dateLabel.textAlignment = .center
    dateContainer.addSubview(dateLabel)

    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateLabel.centerYAnchor.constraint(equalTo: dateContainer.centerYAnchor),
      dateLabel.leadingAnchor.constraint(
        equalTo: dateContainer.leadingAnchor,
        constant: 27
      ),
      dateLabel.trailingAnchor.constraint(
        equalTo: dateContainer.trailingAnchor,
        constant: -27
      )
    ])
  }
}
