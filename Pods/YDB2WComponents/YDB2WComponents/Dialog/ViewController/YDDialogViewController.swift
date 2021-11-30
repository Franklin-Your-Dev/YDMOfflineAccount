//
//  YDDialogViewController.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 17/11/20.
//

import UIKit
import YDExtensions
import YDB2WAssets
import YDB2WColors

public enum YDDialogType {
  case withIcon
  case withCancel
  case simple
}

class YDDialogViewController: UIViewController {
  // MARK: Properties
  var viewModel: YDDialogViewModelDelegate?
  var type: YDDialogType?
  var customIcon: UIImage?
  var customTitle: String?
  var customMessage: String?
  var customButton: String?
  var customCancelButton: String?
  var messageLink: [String: String]?
  var messagesToBold: [String]?

  // MARK: IBOutlets
  @IBOutlet weak var contentView: UIView! {
    didSet {
      contentView.layer.cornerRadius = 16
    }
  }

  @IBOutlet weak var icon: UIImageView! {
    didSet {
      icon.image = YDAssets.Icons.thumbDownWired
      icon.tintColor = YDColors.branding
    }
  }

  @IBOutlet weak var titleLabel: UILabel!

  @IBOutlet weak var descriptionLabel: UILabel!

  @IBOutlet weak var actionButton: YDWireButton!

  @IBOutlet weak var cancelButton: UIButton!

  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareLayout()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    contentView.layer.applyShadow(alpha: 0.08, blur: 20, spread: -1)
  }

  // MARK: IBActions
  @IBAction func onAction(_ sender: UIButton) {
    viewModel?.onButtonAction()
  }

  @IBAction func onCancelAction(_ sender: UIButton) {
    viewModel?.onCancelAction()
  }

  // MARK: Actions
  private func prepareLayout() {
    if let customIcon = customIcon {
      icon.image = customIcon
    }

    if let type = self.type {
      if type == .simple || type == .withCancel {
        icon.removeFromSuperview()
        view.layoutIfNeeded()
      }

      if type == .withCancel {
        cancelButton.isHidden = false
      }
    }

    if let customTitle = customTitle {
      titleLabel.text = customTitle
    }

    if let customMessage = customMessage {
      descriptionLabel.text = customMessage
      
      if let messagesToBold = messagesToBold {
        configureBoldMessages(messagesToBold)
      }
    }

    if let customButton = customButton {
      actionButton.setTitle(customButton, for: .normal)
    }

    if let customCancelButton = customCancelButton {
      cancelButton.setTitle(customCancelButton, for: .normal)
      cancelButton.isHidden = false
    }

    if let messageLink = messageLink,
       let message = messageLink["message"],
       let link = messageLink["link"] {
      addMessageLink(message: message, link: link)
    }
  }
  
  func addMessageLink(message: String, link: String) {
    guard let fullMessage = descriptionLabel.text else { return }

    let attributedString = NSMutableAttributedString(string: fullMessage)

    let location = attributedString.mutableString.range(of: message).location
    let range = NSRange(location: location, length: message.count)

    attributedString.addAttribute(
      NSAttributedString.Key.underlineColor,
      value: YDColors.branding,
      range: range
    )

    attributedString.addAttribute(
      NSAttributedString.Key.foregroundColor,
      value: YDColors.branding,
      range: range
    )

    descriptionLabel.attributedText = attributedString

    let btn = UIButton()
    btn.addTarget(self, action: #selector(onLinkAction), for: .touchUpInside)
    view.addSubview(btn)

    btn.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      btn.topAnchor.constraint(equalTo: descriptionLabel.topAnchor),
      btn.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
      btn.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
      btn.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor)
    ])
  }
  
  func configureBoldMessages(_ messages: [String]) {
    guard let fullMessage = descriptionLabel.text else { return }
    
    var attributedString = NSMutableAttributedString(string: fullMessage)
    
    for message in messages {
      addBoldToMessage(message, onAttributedString: &attributedString)
      addColorToMessage(message, onAttributedString: &attributedString)
    }
    
    descriptionLabel.attributedText = attributedString
  }
  
  func addBoldToMessage(
    _ message: String,
    onAttributedString attributedString: inout NSMutableAttributedString
  ) {
    let location = attributedString.mutableString.range(of: message).location
    let range = NSRange(location: location, length: message.count)
    
    attributedString.addAttribute(
      .font,
      value: UIFont.boldSystemFont(ofSize: 14),
      range: range
    )
  }
  
  func addColorToMessage(
    _ message: String,
    onAttributedString attributedString: inout NSMutableAttributedString
  ) {
    let location = attributedString.mutableString.range(of: message).location
    let range = NSRange(location: location, length: message.count)
    
    attributedString.addAttribute(
      .foregroundColor,
      value: YDColors.Gray.light,
      range: range
    )
  }

  @objc func onLinkAction() {
    viewModel?.onLinkAction(messageLink?["link"])
  }
}
