//
//  ErrorView.swift
//  YDQuiz
//
//  Created by Douglas Hennrich on 23/08/21.
//

import UIKit
import YDB2WComponents
import YDExtensions
import YDB2WColors

class ErrorView: UIView {
  // MARK: Properties
  var callback: ((UIButton) -> Void)? {
    didSet {
      button.callback = callback
    }
  }
  
  // MARK: Components
  let messageLabel = UILabel()
  let button = YDWireButton(withTitle: "atualizar")
  
  // MARK: Init
  init() {
    super.init(frame: .zero)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: UI
extension ErrorView {
  private func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    isHidden = true
    
    configureMessageLabel()
    configureButton()
  }
  
  private func configureMessageLabel() {
    addSubview(messageLabel)
    messageLabel.textColor = YDColors.Gray.light
    messageLabel.font = .systemFont(ofSize: 16)
    messageLabel.textAlignment = .center
    messageLabel.text = "Ops! Falha ao carregar."
    
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      messageLabel.topAnchor.constraint(equalTo: topAnchor),
      messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
    ])
  }
  
  private func configureButton() {
    addSubview(button)
    
    NSLayoutConstraint.activate([
      button.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24),
      button.centerXAnchor.constraint(equalTo: centerXAnchor),
      button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
    ])
  }
}
