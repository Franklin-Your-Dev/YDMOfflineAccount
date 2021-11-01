//
//  SpaceyMultipleChoicesCollectionViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 26/05/21.
//

import UIKit

import YDExtensions
import YDB2WModels
import YDB2WColors

class SpaceyMultipleChoicesCollectionViewCell: UICollectionViewCell {
  // MARK: Properties
  let unselectedBorderColor = UIColor(
    red: 112 / 255,
    green: 112 / 255,
    blue: 112 / 255,
    alpha: 1
  ).cgColor
  let selectedBorderColor = YDColors.branding.cgColor
  
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
  func configure(with choice: YDSpaceyComponentNPSQuestionAnswer) {
    choiceLabel.text = choice.answerText
    setStyle(choice.selected)
  }

  func setStyle(_ selected: Bool) {
    ratioWithinView.isHidden = !selected
    ratioView.layer.borderColor = selected ? selectedBorderColor : unselectedBorderColor
  }
}

// MARK: Layout
extension SpaceyMultipleChoicesCollectionViewCell {
  func configureLayout() {
    configureRatioView()
    configureChoiceLabel()
  }

  func configureRatioView() {
    contentView.addSubview(ratioView)
    ratioView.layer.borderWidth = 1
    ratioView.layer.cornerRadius = 9
    ratioView.layer.borderColor = unselectedBorderColor

    ratioView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      ratioView.widthAnchor.constraint(equalToConstant: 18),
      ratioView.heightAnchor.constraint(equalToConstant: 18),
      ratioView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
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
    choiceLabel.numberOfLines = 0

    choiceLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      choiceLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
      choiceLabel.leadingAnchor.constraint(equalTo: ratioView.trailingAnchor, constant: 16),
      choiceLabel.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -16
      ),
      choiceLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
      choiceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

      ratioView.centerYAnchor.constraint(equalTo: choiceLabel.centerYAnchor)
    ])
  }
}

