//
//  SpaceyOptionCollectionViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 20/05/21.
//

import UIKit

import YDExtensions
import YDB2WModels

class SpaceyOptionCollectionViewCell: UICollectionViewCell {
  // MARK: Components
  let container = UIView()
  let optionLabel = UILabel()

  // MARK: Properties
  private let selectedBackgroundColor = UIColor(
    red: 102 / 255,
    green: 102 / 255,
    blue: 102 / 255,
    alpha: 1
  )
  private let selectedLabelColor = UIColor(
    red: 255 / 255,
    green: 255 / 255,
    blue: 255 / 255,
    alpha: 1
  )

  private let unselectedBackgroundColor = UIColor(
    red: 235 / 255,
    green: 235 / 255,
    blue: 235 / 255,
    alpha: 1
  )
  private let unselectedLabelColor = UIColor(
    red: 112 / 255,
    green: 112 / 255,
    blue: 112 / 255,
    alpha: 1
  )

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      contentView.heightAnchor.constraint(equalToConstant: 40),
      contentView.topAnchor.constraint(equalTo: topAnchor),
      contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])

    configureLayout()
    configureOptionLabel()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Configure
  func configure(with option: YDSpaceyComponentNPSQuestionAnswer) {
    optionLabel.text = option.answerText
    setStyle(option.selected)
  }

  func setStyle(_ selected: Bool) {
    container.backgroundColor = selected ?
      selectedBackgroundColor : unselectedBackgroundColor

    optionLabel.textColor = selected ?
      selectedLabelColor : unselectedLabelColor
  }
}

// MARK: Layout
extension SpaceyOptionCollectionViewCell {
  func configureLayout() {
    configureContainer()
    configureOptionLabel()
  }

  func configureContainer() {
    contentView.addSubview(container)
    container.backgroundColor = unselectedBackgroundColor
    container.layer.cornerRadius = 20

    container.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      container.heightAnchor.constraint(equalToConstant: 40),
      container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    ])
    container.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
  }

  func configureOptionLabel() {
    container.addSubview(optionLabel)
    optionLabel.font = .systemFont(ofSize: 14)
    optionLabel.textColor = unselectedLabelColor
    optionLabel.textAlignment = .center

    optionLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      optionLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
      optionLabel.leadingAnchor.constraint(
        equalTo: container.leadingAnchor,
        constant: 22
      ),
      optionLabel.trailingAnchor.constraint(
        equalTo: container.trailingAnchor,
        constant: -22
      )
    ])
    optionLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
  }
}
