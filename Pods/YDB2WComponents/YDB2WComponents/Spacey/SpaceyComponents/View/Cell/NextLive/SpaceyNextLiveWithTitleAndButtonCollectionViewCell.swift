//
//  SpaceyNextLiveWithTitleAndButtonCollectionViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 17/08/21.
//

import UIKit
import YDB2WModels
import YDExtensions
import YDB2WColors

class SpaceyNextLiveWithTitleAndButtonCollectionViewCell: UICollectionViewCell {
  // MARK: Properties
  var buttonCallback: ((UIButton) -> Void)? {
    didSet {
      button.callback = buttonCallback
    }
  }
  var scheduleButtonCallback: (() -> Void)? {
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
  
  let titleLabel = UILabel()
  lazy var titleLabelTopConstraint: NSLayoutConstraint = {
    titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6)
  }()
  lazy var titleLabelHeightConstraint: NSLayoutConstraint = {
    titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 28)
  }()
  
  let nextLiveView = YDNextLiveView(hasButton: true)
  lazy var nextLiveViewTopConstraint: NSLayoutConstraint = {
    nextLiveView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16)
  }()
  
  let button = YDWireButton()
  lazy var buttonTopConstraint: NSLayoutConstraint = {
    button.topAnchor.constraint(equalTo: nextLiveView.bottomAnchor, constant: 12)
  }()

  // MARK: Init
  override func prepareForReuse() {
    super.prepareForReuse()
    nextLiveView.cleanUp()
    buttonCallback = nil
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
  func configure(
    with live: YDSpaceyComponentNextLive?,
    withTitle title: String?,
    withButtonTitle buttonTitle: String?
  ) {
    nextLiveView.config(with: live)
    
    configureTitle(title)
    configureButtonTitle(buttonTitle)
  }
  
  private func configureTitle(_ title: String?) {
    guard let title = title,
          !title.isEmpty
    else {
      titleLabelTopConstraint.constant = 0
      titleLabelHeightConstraint.constant = 0
      nextLiveViewTopConstraint.constant = 0
      return
    }
    
    titleLabel.text = title
  }
  
  private func configureButtonTitle(_ title: String?) {
    guard let title = title,
          !title.isEmpty
    else {
      button.buttonHeightConstraint.constant = 0
      buttonTopConstraint.constant = 0
      return
    }
    
    button.setTitle(title, for: .normal)
  }
}

// MARK: UI
extension SpaceyNextLiveWithTitleAndButtonCollectionViewCell {
  private func configureLayout() {
    configureTitle()
    configureNextLiveView()
    configureButton()
  }
  
  private func configureTitle() {
    contentView.addSubview(titleLabel)

    titleLabel.textColor = YDColors.black
    titleLabel.font = .boldSystemFont(ofSize: 24)
    titleLabel.numberOfLines = 2
    titleLabel.textAlignment = .left

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor
        .constraint(equalTo: contentView.leadingAnchor,constant: 16),
      titleLabel.trailingAnchor
        .constraint(equalTo: contentView.trailingAnchor,constant: -16)
    ])
    titleLabelTopConstraint.isActive = true
    titleLabelHeightConstraint.isActive = true
  }

  private func configureNextLiveView() {
    contentView.addSubview(nextLiveView)
    nextLiveView.callback = scheduleButtonCallback

    NSLayoutConstraint.activate([
      nextLiveView.leadingAnchor
        .constraint(equalTo: contentView.leadingAnchor, constant: 16),
      nextLiveView.trailingAnchor
        .constraint(equalTo: contentView.trailingAnchor, constant: -16)
    ])
    nextLiveViewTopConstraint.isActive = true
  }

  private func configureButton() {
    contentView.addSubview(button)
    button.callback = buttonCallback

    NSLayoutConstraint.activate([
      button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
    ])
    buttonTopConstraint.isActive = true
  }
}
