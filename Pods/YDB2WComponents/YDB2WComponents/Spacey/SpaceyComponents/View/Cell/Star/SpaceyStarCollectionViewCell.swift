//
//  SpaceyStarCollectionViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 20/05/21.
//

import UIKit

import YDB2WModels

class SpaceyStarCollectionViewCell: UICollectionViewCell {
  // MARK: Components
  lazy var width: NSLayoutConstraint = {
    let width = contentView.widthAnchor
      .constraint(equalToConstant: bounds.size.width)
    width.isActive = true
    return width
  }()
  let starComponent = SpaceyStarComponentView()

  // MARK: Properties
  var starNumber: Double {
    get {
      starComponent.starNumber
    }
    set {
      starComponent.starNumber = newValue
    }
  }
  var callback: ((_ starNumber: Double) -> Void)? {
    didSet {
      starComponent.callback = callback
    }
  }

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    configureStarComponent()
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

  override func prepareForReuse() {
    super.prepareForReuse()
    callback = nil
  }

  // MARK: Configure
  func configure(with component: YDSpaceyComponentNPSQuestion) {
    starComponent.configure(with: component)
  }
}

// MARK: Layout
extension SpaceyStarCollectionViewCell {
  func configureStarComponent() {
    contentView.addSubview(starComponent)

    NSLayoutConstraint.activate([
      starComponent.topAnchor.constraint(equalTo: contentView.topAnchor),
      starComponent.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor,
        constant: 16
      ),
      starComponent.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -16
      ),
      starComponent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
}
