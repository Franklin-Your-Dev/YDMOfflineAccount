//
//  YDNextLiveSpaceyCell.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 06/07/21.
//

import UIKit
import YDB2WModels

public class YDNextLiveSpaceyCell: UICollectionViewCell {
  // MARK: Properties
  public var buttonCallback: ((UIButton) -> Void)? {
    didSet {
      button.callback = buttonCallback
    }
  }
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
  let button = YDWireButton(withTitle: "confira nossa programação completa")

  // MARK: Init
  public override func prepareForReuse() {
    super.prepareForReuse()
    nextLiveView.cleanUp()
    buttonCallback = nil
    scheduleButtonCallback = nil
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.translatesAutoresizingMaskIntoConstraints = false

    configureLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func systemLayoutSizeFitting(
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
  public func configure(with live: YDSpaceyComponentNextLive?) {
    nextLiveView.config(with: live)
  }
}

// MARK: UI
extension YDNextLiveSpaceyCell {
  private func configureLayout() {
    configureNextLiveView()
    configureButton()
  }

  private func configureNextLiveView() {
    contentView.addSubview(nextLiveView)
    nextLiveView.callback = scheduleButtonCallback

    NSLayoutConstraint.activate([
      nextLiveView.topAnchor.constraint(equalTo: contentView.topAnchor),
      nextLiveView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      nextLiveView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    ])
  }

  private func configureButton() {
    contentView.addSubview(button)
    button.callback = buttonCallback

    NSLayoutConstraint.activate([
      button.topAnchor.constraint(equalTo: nextLiveView.bottomAnchor, constant: 12),
      button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
    ])
  }
}
