//
//  SpaceyNextLiveCollectionViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 17/08/21.
//

import UIKit
import YDB2WModels

class SpaceyNextLiveCollectionViewCell: UICollectionViewCell {
  // MARK: Properties
  public var scheduleButtonCallback: (() -> Void)? {
    didSet {
      nextLiveView.callback = scheduleButtonCallback
    }
  }

  // MARK: Components
  lazy var width: NSLayoutConstraint = {
    let width = contentView.widthAnchor
      .constraint(equalToConstant: bounds.size.width)
    width.isActive = true
    return width
  }()
  let nextLiveView = YDNextLiveView(hasButton: true)

  // MARK: Init
  override func prepareForReuse() {
    super.prepareForReuse()
    nextLiveView.cleanUp()
    scheduleButtonCallback = nil
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.translatesAutoresizingMaskIntoConstraints = false

    configureLayout()
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

  // MARK: Actions
  func configure(with live: YDSpaceyComponentNextLive?) {
    nextLiveView.config(with: live)
  }
}

// MARK: UI
extension SpaceyNextLiveCollectionViewCell {
  private func configureLayout() {
    configureNextLiveView()
  }

  private func configureNextLiveView() {
    contentView.addSubview(nextLiveView)
    nextLiveView.callback = scheduleButtonCallback

    NSLayoutConstraint.activate([
      nextLiveView.topAnchor.constraint(equalTo: contentView.topAnchor),
      nextLiveView.leadingAnchor
        .constraint(equalTo: contentView.leadingAnchor, constant: 16),
      nextLiveView.trailingAnchor
        .constraint(equalTo: contentView.trailingAnchor, constant: -16)
    ])
  }
}
