//
//  YDSpaceyCustomTitleCell.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 22/06/21.
//

import UIKit
import YDExtensions
import YDB2WColors

public class YDSpaceyCustomTitleCell: UICollectionViewCell {
  // MARK: Components
  lazy var width: NSLayoutConstraint = {
    let width = contentView.widthAnchor
      .constraint(equalToConstant: bounds.size.width)
    width.isActive = true
    return width
  }()

  let titleLabel = UILabel()

  // MARK: Init
  public override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    configureLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel.text = nil
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
  public func configure(title: String?) {
    titleLabel.text = title
  }
}

// MARK: UI
extension YDSpaceyCustomTitleCell {
  private func configureLayout() {
    contentView.addSubview(titleLabel)
    titleLabel.textColor = YDColors.black
    titleLabel.font = .boldSystemFont(ofSize: 24)
    titleLabel.numberOfLines = 2
    titleLabel.textAlignment = .left

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
      titleLabel.leadingAnchor
        .constraint(equalTo: contentView.leadingAnchor, constant: 16),
      titleLabel.trailingAnchor
        .constraint(equalTo: contentView.trailingAnchor, constant: -16),
      titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 28)
    ])
  }
}
