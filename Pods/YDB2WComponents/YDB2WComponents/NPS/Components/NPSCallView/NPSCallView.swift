//
//  NPSInLineButton.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 23/09/21.
//

import UIKit
import YDExtensions
import YDB2WAssets
import YDB2WColors

public class NPSCallView: UIView {
  // MARK: Properties
  let padding: CGFloat = 16
  
  public var callback: (() -> Void)?
  
  // MARK: Components
  public lazy var heightConstraint: NSLayoutConstraint = {
    heightAnchor.constraint(equalToConstant: 60)
  }()
  let descriptionLabel = UILabel()
  let remainingDaysLabel = UILabel()
  let arrowIconImageView = UIImageView()

  // MARK: Init
  public init() {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    heightConstraint.isActive = true
    
    configureUI()
    
    addGestureRecognizer(
      UITapGestureRecognizer(target: self, action: #selector(onTapAction))
    )
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Actions
  public func configure(remainingDays: String) {
    guard let convertToInt = Int(remainingDays) else {
      return
    }
    
    changeMessageWith(remainingDays: convertToInt)
  }
  
  public func configure(remainingDays: Int) {
    changeMessageWith(remainingDays: remainingDays)
  }
  
  private func changeMessageWith(remainingDays: Int) {
    var message = ""
    
    switch remainingDays {
      case 0:
        message = "Hoje é o último dia para avaliar :)"
        
      case 1:
        message = "você tem apenas 1 dia para avaliar"
        
      default:
        message = "Você tem até \(remainingDays) dias pra avaliar ;)"
    }
    
    remainingDaysLabel.text = message
  }
  
  @objc private func onTapAction() {
    callback?()
  }
}

// MARK: UI
extension NPSCallView {
  private func configureUI() {
    configureDescriptionLabel()
    configureRemainingDaysLabel()
    configureArrowIconImageView()
  }
  
  private func configureDescriptionLabel() {
    addSubview(descriptionLabel)
    descriptionLabel.textColor = YDColors.Gray.light
    descriptionLabel.font = .boldSystemFont(ofSize: 16)
    descriptionLabel.text = "como foi sua visita na loja?"
    descriptionLabel.textAlignment = .left
    
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      descriptionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
      descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
      descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
    ])
  }
  
  private func configureRemainingDaysLabel() {
    addSubview(remainingDaysLabel)
    remainingDaysLabel.textColor = YDColors.Gray.light
    remainingDaysLabel.font = .systemFont(ofSize: 12)
    
    remainingDaysLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      remainingDaysLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
      remainingDaysLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      remainingDaysLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
    ])
  }
  
  private func configureArrowIconImageView() {
    addSubview(arrowIconImageView)
    arrowIconImageView.tintColor = YDColors.Gray.light
    arrowIconImageView.image = YDAssets.Icons.chevronRight
    
    arrowIconImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      arrowIconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      arrowIconImageView.widthAnchor.constraint(equalToConstant: 30),
      arrowIconImageView.heightAnchor.constraint(equalToConstant: 30),
      arrowIconImageView.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -(padding / 2)
      )
    ])
  }
}
