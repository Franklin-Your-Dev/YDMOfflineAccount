//
//  YDQuizChoiceCollectionViewCell.swift
//  YDQuiz
//
//  Created by Douglas Hennrich on 02/07/21.
//

import UIKit
import YDExtensions
import YDB2WModels
import YDB2WColors

class YDQuizChoiceCollectionViewCell: UICollectionViewCell {
  // MARK: Components
  lazy var width: NSLayoutConstraint = {
    let width = contentView.widthAnchor
      .constraint(equalToConstant: bounds.size.width)
    width.isActive = true
    return width
  }()
  let ratioView = UIView()
  let ratioWithinView = UIView()
  let choiceLabel = UILabel()

  // MARK: Init
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

  // MARK: Configure
  func configure(with choice: YDQuizChoice) {
    choiceLabel.text = choice.title
    setStyle(choice.selected)
  }

  func setStyle(_ selected: Bool) {
    ratioWithinView.isHidden = !selected

    ratioView.layer.borderColor = selected ?
      YDColors.branding.cgColor :
      YDColors.Gray.light.cgColor
  }
}

// MARK: UI
extension YDQuizChoiceCollectionViewCell {
  func configureLayout() {
    configureRatioView()
    configureChoiceLabel()
  }

  func configureRatioView() {
    contentView.addSubview(ratioView)
    ratioView.layer.borderWidth = 1
    ratioView.layer.cornerRadius = 9
    ratioView.layer.borderColor = YDColors.Gray.light.cgColor

    ratioView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      ratioView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
      ratioView.widthAnchor.constraint(equalToConstant: 18),
      ratioView.heightAnchor.constraint(equalToConstant: 18),
      ratioView.leadingAnchor
        .constraint(equalTo: contentView.leadingAnchor, constant: 16)
    ])

    //
    ratioView.addSubview(ratioWithinView)
    ratioWithinView.backgroundColor = YDColors.branding
    ratioWithinView.layer.cornerRadius = 5

    ratioWithinView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      ratioWithinView.centerXAnchor.constraint(equalTo: ratioView.centerXAnchor),
      ratioWithinView.centerYAnchor.constraint(equalTo: ratioView.centerYAnchor),
      ratioWithinView.widthAnchor.constraint(equalToConstant: 10),
      ratioWithinView.heightAnchor.constraint(equalToConstant: 10)
    ])
  }

  func configureChoiceLabel() {
    contentView.addSubview(choiceLabel)
    choiceLabel.font = .systemFont(ofSize: 14)
    choiceLabel.textColor = YDColors.Gray.light
    choiceLabel.textAlignment = .left
    choiceLabel.numberOfLines = 2

    choiceLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      choiceLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
      choiceLabel.leadingAnchor.constraint(equalTo: ratioView.trailingAnchor, constant: 16),
      choiceLabel.trailingAnchor
        .constraint(equalTo: contentView.trailingAnchor, constant: -16),
      choiceLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
      choiceLabel.bottomAnchor
        .constraint(equalTo: contentView.bottomAnchor, constant: -8)
    ])
  }
}
