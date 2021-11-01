//
//  YDErrorView.swift
//  YDMstoreModeOfflineAccount
//
//  Created by Douglas Hennrich on 05/05/21.
//

import UIKit

import YDExtensions
import YDB2WComponents
import YDB2WColors

class YDErrorView: UIView {
  // MARK: Properties
  var callback: ((UIButton) -> Void)? {
    didSet {
      actionButton.callback = callback
    }
  }

  // MARK: Components
  let messageLabel = UILabel()
  let actionButton = YDWireButton(withTitle: "atualizar")

  // MARK: Init
  init() {
    super.init(frame: .zero)
    backgroundColor = .white
    translatesAutoresizingMaskIntoConstraints = false

    configureMessageLabel()
    configureActionButton()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Layout
extension YDErrorView {
  func configureMessageLabel() {
    addSubview(messageLabel)

    messageLabel.textColor = YDColors.Gray.light
    messageLabel.font = .systemFont(ofSize: 16)
    messageLabel.textAlignment = .center
    messageLabel.text = "Ops! Falha ao carregar."

    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 46),
      messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
      messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
    ])
  }

  func configureActionButton() {
    addSubview(actionButton)

    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      actionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
      actionButton.centerXAnchor.constraint(equalTo: centerXAnchor)
    ])

    actionButton.callback = callback
  }
}
