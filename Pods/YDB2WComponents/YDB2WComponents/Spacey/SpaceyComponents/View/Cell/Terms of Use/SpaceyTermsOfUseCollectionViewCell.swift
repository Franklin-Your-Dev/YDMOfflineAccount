//
//  SpaceyTermsOfUseCollectionViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 04/06/21.
//

import UIKit
import YDB2WModels
import YDExtensions

class SpaceyTermsOfUseCollectionViewCell: UICollectionViewCell {
  // MARK: Components
  lazy var width: NSLayoutConstraint = {
    let width = contentView.widthAnchor
      .constraint(equalToConstant: bounds.size.width)
    width.isActive = true
    return width
  }()

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    configure()
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

  // MARK: Configure
  func configure(with component: YDSpaceyComponentTermsOfUse) {}
}

// MARK: UI
extension SpaceyTermsOfUseCollectionViewCell {
  private func configure() {}
}
