//
//  YDCountDownViewCell.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 10/06/21.
//

import UIKit

public class YDCountDownViewCell: UICollectionViewCell {
  // MARK: Components
  lazy var width: NSLayoutConstraint = {
    let width = contentView.widthAnchor
      .constraint(equalToConstant: bounds.size.width)
    width.isActive = true
    return width
  }()
  let countDownView = YDCountDownView()

  // MARK: Init
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
  public func start(with date: Date) {
    countDownView.start(with: date)

//    MOCK
//    if let nextDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date()) {
//      countDownView.start(with: nextDate)
//    }
  }
}

// MARK: UI
extension YDCountDownViewCell {
  func configureLayout() {
    contentView.addSubview(countDownView)
    NSLayoutConstraint.activate([
      countDownView.topAnchor.constraint(equalTo: contentView.topAnchor),
      countDownView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      countDownView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      countDownView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
}
