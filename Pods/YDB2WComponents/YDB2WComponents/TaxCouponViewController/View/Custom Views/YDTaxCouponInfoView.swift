//
//  YDTaxCouponInfoView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 25/08/21.
//

import UIKit
import YDExtensions
import YDB2WColors

class YDTaxCouponInfoView: UIView {
  // MARK: Components
  let titleLabel = UILabel()
  let valueLabel = UILabel()
  
  // MARK: Init
  init(title: String) {
    super.init(frame: .zero)
    configureUI()
    
    titleLabel.text = "\(title):"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Config
  func configure(withValue value: String?) {
    valueLabel.text = value
  }
}

// MARK: UI
extension YDTaxCouponInfoView {
  private func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    heightAnchor.constraint(equalToConstant: 16).isActive = true
    
    configureTitleLabel()
    configureValueLabel()
  }
  
  private func configureTitleLabel() {
    addSubview(titleLabel)
    titleLabel.font = .systemFont(ofSize: 13)
    titleLabel.textColor = YDColors.black
    titleLabel.textAlignment = .left
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  private func configureValueLabel() {
    addSubview(valueLabel)
    valueLabel.font = .systemFont(ofSize: 13)
    valueLabel.textColor = YDColors.black
    valueLabel.textAlignment = .right
    
    valueLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
}
