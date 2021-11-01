//
//  YDReplyMessageComponent.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 13/05/21.
//

import UIKit

import YDB2WModels

public class YDReplyMessageComponent: UIView {
  // MARK: Enum
  public enum Stage {
    case typing
    case replied
  }

  // MARK: Properties
  public var stage: Stage = .typing {
    didSet {
      changeUIState(with: stage)
    }
  }
  public var onTapCallback: ((_ messageComponent: YDChatMessage?) -> Void)?
  public var onCancelCallback: (() -> Void)?
  var currentMessage: YDChatMessage?

  // MARK: Components
  let container = UIView()
  lazy var leadingContainerConstraint: NSLayoutConstraint = {
    return container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
  }()

  let leftView = UIView()
  let usernameLabel = UILabel()
  let messageLabel = UILabel()
  lazy var trailingMessageConstraint: NSLayoutConstraint = {
    return messageLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -60)
  }()

  let actionButton = UIButton()
  let arrowIcon = UIImageView()

  // MARK: Init
  public init() {
    super.init(frame: .zero)

    configureLayout()
    let tap = UITapGestureRecognizer(target: self, action: #selector(onTapAction))
    container.addGestureRecognizer(tap)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Actions
  public func configure(with messageComponent: YDChatMessage) {
    usernameLabel.text = messageComponent.sender.name
    messageLabel.text = messageComponent.message
    currentMessage = messageComponent
  }

  @objc func onActionButton() {
    onCancelCallback?()
    currentMessage = nil
  }

  @objc func onTapAction() {
    if stage == .replied {
      onTapCallback?(currentMessage)
    }
  }

  func changeUIState(with stage: Stage) {
    stage == .typing ? changeToTyping() : changeToReplied()
  }

  func changeToTyping() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }

      self.leadingContainerConstraint.constant = 0
      self.trailingMessageConstraint.constant = -60
      self.container.layer.cornerRadius = 0
      self.arrowIcon.isHidden = true
      self.actionButton.isHidden = false
      self.layoutIfNeeded()
    }
  }

  func changeToReplied() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }

      self.leadingContainerConstraint.constant = 44
      self.trailingMessageConstraint.constant = -6
      self.container.layer.maskedCorners = [.layerMinXMinYCorner]
      self.container.layer.cornerRadius = 8
      self.arrowIcon.isHidden = false
      self.actionButton.isHidden = true
      self.layoutIfNeeded()
    }
  }
}
