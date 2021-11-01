//
//  YDHighlighMessageView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 20/07/21.
//

import UIKit
import YDExtensions
import YDB2WAssets
import YDB2WModels
import YDB2WColors

public class YDHighlighMessageView: UIView {
  // MARK: Components
  let iconImageView = UIImageView()
  let messageLabel = UILabel()

  // MARK: Init
  public init() {
    super.init(frame: .zero)
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
  }

  // MARK: Configure
  public func configure(message: String) {
    messageLabel.text = message
    layoutIfNeeded()
  }
}

// MARK: UI
extension YDHighlighMessageView {
  private func configure() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .white
    layer.applyShadow()

    configureIconImageView()
    configureMessageLabel()
  }

  private func configureIconImageView() {
    addSubview(iconImageView)
    iconImageView.tintColor = YDColors.black
    iconImageView.image = YDAssets.Icons.heart

    iconImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      iconImageView.widthAnchor.constraint(equalToConstant: 18),
      iconImageView.heightAnchor.constraint(equalToConstant: 18),
      iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
      iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8)
    ])
  }

  private func configureMessageLabel() {
    addSubview(messageLabel)
    messageLabel.font = .boldSystemFont(ofSize: 12)
    messageLabel.textColor = YDColors.black
    messageLabel.textAlignment = .left
    messageLabel.numberOfLines = 0

    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      messageLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 6),
      messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
      messageLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 12),
      messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
    ])
  }
}
