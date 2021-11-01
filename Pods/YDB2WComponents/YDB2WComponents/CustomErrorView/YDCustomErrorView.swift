//
//  YDCustomErrorView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 17/06/21.
//

import UIKit
import YDExtensions
import YDB2WColors

public class YDCustomErrorView: UIView {
  // MARK: Properties
  public var callback: (() -> Void)?

  // MARK: Components
  public let container = UIView()
  let messageLabel = UILabel()
  let actionButton = UIButton()
  lazy var actionButtonTopConstraint: NSLayoutConstraint = {
    let top = actionButton.topAnchor
      .constraint(equalTo: messageLabel.bottomAnchor, constant: 12)
    return top
  }()

  // MARK: Init
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override init(frame: CGRect) {
    super.init(frame: .zero)
  }

  public init(message: String, buttonBorder: Bool = false) {
    super.init(frame: .zero)
    configure()

    messageLabel.text = message

    if buttonBorder {
      actionButton.layer.borderWidth = 1.5
      actionButton.layer.borderColor = YDColors.branding.cgColor
      actionButtonTopConstraint.constant = 22
    } else {
      actionButton.layer.borderWidth = 0
      actionButton.layer.borderColor = nil
      actionButtonTopConstraint.constant = 12
    }
  }

  public func show() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.isHidden = false

      UIView.animate(withDuration: 0.3) {
        self.alpha = 1
      }
    }
  }

  public func hide() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      UIView.animate(withDuration: 0.3) {
        self.alpha = 0
      } completion: { _ in
        self.isHidden = false
      }
    }
  }

  @objc private func onAction() {
    callback?()
    hide()
  }
}

// MARK: UI
extension YDCustomErrorView {
  private func configure() {
    translatesAutoresizingMaskIntoConstraints = false
    alpha = 0
    isHidden = true

    configureContainer()
    configureMessage()
    configureActionButton()
  }

  private func configureContainer() {
    addSubview(container)

    container.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      container.topAnchor.constraint(equalTo: topAnchor),
      container.leadingAnchor.constraint(equalTo: leadingAnchor),
      container.trailingAnchor.constraint(equalTo: trailingAnchor),
      container.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  private func configureMessage() {
    container.addSubview(messageLabel)
    messageLabel.font = .systemFont(ofSize: 16)
    messageLabel.textColor = YDColors.Gray.light
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = .center

    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      messageLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
      messageLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20)
    ])

    NSLayoutConstraint(
      item: messageLabel,
      attribute: .centerY,
      relatedBy: .equal,
      toItem: container,
      attribute: .centerY,
      multiplier: 0.8,
      constant: 0
    ).isActive = true
  }

  private func configureActionButton() {
    container.addSubview(actionButton)

    let attributedString = NSAttributedString(
      string: "atualizar",
      attributes: [
        NSAttributedString.Key.foregroundColor: YDColors.branding,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)
      ]
    )
    actionButton.setAttributedTitle(attributedString, for: .normal)
    actionButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    actionButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    actionButton.layer.cornerRadius = 4

    actionButton.addTarget(self, action: #selector(onAction), for: .touchUpInside)

    actionButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      actionButton.heightAnchor.constraint(equalToConstant: 40),
      actionButton.centerXAnchor.constraint(equalTo: container.centerXAnchor)
    ])
    actionButtonTopConstraint.isActive = true
  }
}
