//
//  YDReplyMessageComponent+Layouts.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 13/05/21.
//

import UIKit

import YDExtensions
import YDB2WAssets
import YDB2WColors

extension YDReplyMessageComponent {
  func configureLayout() {
    backgroundColor = .clear
    translatesAutoresizingMaskIntoConstraints = false
    clipsToBounds = true

    configureContainerView()
    configureLeftView()
    configureUsernameLabel()
    configureActionButton()
    configureMessageLabel()
    configureArrowIcon()
  }

  // Container
  func configureContainerView() {
    addSubview(container)
    container.backgroundColor = YDColors.Red.pale
    container.layer.masksToBounds = true

    container.translatesAutoresizingMaskIntoConstraints = false
    leadingContainerConstraint.isActive = true
    NSLayoutConstraint.activate([
      container.topAnchor.constraint(equalTo: topAnchor),
      container.trailingAnchor.constraint(equalTo: trailingAnchor),
      container.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  // Left red view
  func configureLeftView() {
    container.addSubview(leftView)
    leftView.backgroundColor = YDColors.branding

    leftView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      leftView.topAnchor.constraint(equalTo: container.topAnchor),
      leftView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
      leftView.widthAnchor.constraint(equalToConstant: 4),
      leftView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
    ])
  }

  // Username label
  func configureUsernameLabel() {
    container.addSubview(usernameLabel)

    usernameLabel.font = UIFont.systemFont(ofSize: 12).bold().italic()
    usernameLabel.textColor = YDColors.Gray.light
    usernameLabel.textAlignment = .left

    usernameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      usernameLabel.leadingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: 8),
      usernameLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
    ])
    usernameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    usernameLabel.setContentCompressionResistancePriority(
      .defaultHigh,
      for: .horizontal
    )
  }

  // Message label
  func configureMessageLabel() {
    container.addSubview(messageLabel)

    messageLabel.font = .italicSystemFont(ofSize: 12)
    messageLabel.textColor = YDColors.Gray.light
    messageLabel.textAlignment = .left

    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    trailingMessageConstraint.isActive = true
    NSLayoutConstraint.activate([
      messageLabel.leadingAnchor.constraint(equalTo: usernameLabel.trailingAnchor, constant: 6),
      messageLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
    ])
    messageLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    messageLabel.setContentCompressionResistancePriority(
      .defaultLow,
      for: .horizontal
    )
  }

  // Action button
  func configureActionButton() {
    container.addSubview(actionButton)
    actionButton.tintColor = YDColors.Gray.light
    actionButton.setImage(YDAssets.Icons.times, for: .normal)

    actionButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      actionButton.topAnchor.constraint(equalTo: container.topAnchor),
      actionButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -17),
      actionButton.widthAnchor.constraint(equalToConstant: 34),
      actionButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
    ])

    actionButton.addTarget(self, action: #selector(onActionButton), for: .touchUpInside)
  }

  // Arrow icon imageView
  func configureArrowIcon() {
    addSubview(arrowIcon)
    arrowIcon.isHidden = true

    arrowIcon.tintColor = YDColors.Gray.night
    arrowIcon.image = YDAssets.Icons.curvedRightArrow

    arrowIcon.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      arrowIcon.trailingAnchor.constraint(
        equalTo: container.leadingAnchor,
        constant: -8
      ),
      arrowIcon.topAnchor.constraint(equalTo: topAnchor, constant: 3),
      arrowIcon.widthAnchor.constraint(equalToConstant: 28),
      arrowIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3)
    ])
  }
}

//
private extension UIFont {
  //Add Traits
  func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
    let symTraits = fontDescriptor.symbolicTraits
    let descriptor = fontDescriptor.withSymbolicTraits(
      UIFontDescriptor.SymbolicTraits(arrayLiteral: symTraits, traits)
    )
    return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
  }

  func bold() -> UIFont {
    return withTraits(traits: .traitBold)
  }

  func italic() -> UIFont {
    return withTraits(traits: .traitItalic)
  }
}
