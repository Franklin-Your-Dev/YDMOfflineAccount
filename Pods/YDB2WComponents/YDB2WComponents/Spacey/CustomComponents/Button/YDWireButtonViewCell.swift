//
//  YDWireButtonViewCell.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 10/06/21.
//

import UIKit

public class YDWireButtonViewCell: UICollectionViewCell {
  // MARK: Properties
  public var callback: ((UIButton) -> Void)? {
    didSet {
      button.callback = callback
    }
  }

  // MARK: Components
  lazy var width: NSLayoutConstraint = {
    let width = contentView.widthAnchor
      .constraint(equalToConstant: bounds.size.width)
    width.isActive = true
    return width
  }()
  let button = YDWireButton()

  // MARK: Init
  public override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    configureUI()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func prepareForReuse() {
    callback = nil
    super.prepareForReuse()
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
  public func configure(withTitle title: String?) {
    button.setTitle(title, for: .normal)
  }
}

// MARK: UI
extension YDWireButtonViewCell {
  func configureUI() {
    contentView.addSubview(button)
    button.callback = callback

    NSLayoutConstraint.activate([
      button.topAnchor.constraint(equalTo: contentView.topAnchor),
      button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
    ])
  }
}
