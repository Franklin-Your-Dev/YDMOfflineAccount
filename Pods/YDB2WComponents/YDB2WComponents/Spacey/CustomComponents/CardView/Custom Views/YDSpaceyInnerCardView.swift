//
//  YDSpaceyInnerCardView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 10/06/21.
//

import UIKit
import YDExtensions
import YDB2WAssets
import YDB2WModels
import YDB2WColors

class YDSpaceyInnerCardView: UIView {
  // MARK: Components
  let iconContainer = UIView()
  let iconImageView = UIImageView()
  let titleContainer = UIView()
  let titleLabel = UILabel()

  // MARK: Init
  init(with card: YDSpaceyComponentLiveNPSCardQuestion) {
    super.init(frame: .zero)
    configureUI()

    titleLabel.text = card.title
    iconImageView.setImage(card.image, placeholder: YDAssets.Icons.imagePlaceHolder)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: UI
extension YDSpaceyInnerCardView {
  func configureUI() {
    configureIconImageView()
    configureTitleLabel()
  }

  func configureIconImageView() {
    addSubview(iconContainer)
    iconContainer.layer.borderWidth = 2
    iconContainer.layer.borderColor = YDColors.branding.cgColor
    iconContainer.layer.cornerRadius = 4

    iconContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      iconContainer.topAnchor.constraint(equalTo: topAnchor),
      iconContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      iconContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
      iconContainer.widthAnchor.constraint(equalToConstant: 72),
      iconContainer.heightAnchor.constraint(equalToConstant: 72)
    ])

    iconContainer.addSubview(iconImageView)
    iconImageView.contentMode = .scaleAspectFit
    iconImageView.tintColor = YDColors.Gray.night
    iconImageView.image = YDAssets.Icons.imagePlaceHolder

    iconImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
      iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
      iconImageView.widthAnchor.constraint(equalToConstant: 58),
      iconImageView.heightAnchor.constraint(equalToConstant: 58)
    ])
  }

  func configureTitleLabel() {
    addSubview(titleContainer)
    titleContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleContainer.topAnchor.constraint(equalTo: iconContainer.bottomAnchor, constant: 12),
      titleContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
      titleContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
      titleContainer.heightAnchor.constraint(equalToConstant: 24),
      titleContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
    titleContainer.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

    //
    titleContainer.addSubview(titleLabel)
    titleLabel.textColor = YDColors.black
    titleLabel.font = .boldSystemFont(ofSize: 10)
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 2

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: titleContainer.topAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor),
      titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 12)
    ])
  }
}
