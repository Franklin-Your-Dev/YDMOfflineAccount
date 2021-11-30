//
//  StoreNameAndAddressView.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 08/09/21.
//

import UIKit
import YDB2WModels
import YDExtensions
import YDB2WAssets
import YDB2WColors

class StoreNameAndAddressView: UIView {
  // MARK: Properties
  lazy var shimmers: [UIView] = {
    [
      logoImageView,
      storeNameLabel,
      addressLabel,
      adressLabelShimmer
    ]
  }()
  
  // MARK: Components
  let logoImageView = UIImageView()
  let storeNameLabel = UILabel()
  let addressLabel = UILabel()
  let adressLabelShimmer = UIView()
  
  // MARK: Init
  init() {
    super.init(frame: .zero)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Actions
  func startShimmers() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.shimmers.forEach { $0.startShimmer() }
      self.adressLabelShimmer.isHidden = false
    }
  }
  
  func stopShimmers() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.shimmers.forEach { $0.stopShimmer() }
      self.adressLabelShimmer.isHidden = true
    }
  }
  
  func configure(with order: YDOfflineOrdersOrder ) {
    storeNameLabel.text = order.formattedStoreName
    addressLabel.text = order.formattedAddress
  }
  
  func reset() {
    storeNameLabel.text = nil
    addressLabel.text = nil
  }
}

// MARK: UI
extension StoreNameAndAddressView {
  private func configureUI() {
    configureView()
    configureLogoImageView()
    configureStoreNameLabel()
    configureAddressLabel()
    configureAddressLabelShimmer()
  }
  
  private func configureView() {
    translatesAutoresizingMaskIntoConstraints = false
    heightAnchor.constraint(equalToConstant: 55).isActive = true
  }
  
  private func configureLogoImageView() {
    addSubview(logoImageView)
    logoImageView.backgroundColor = YDColors.branding
    logoImageView.layer.cornerRadius = 8
    logoImageView.image = YDAssets.Images.logoSmall
    logoImageView.layer.applyShadow()
    
    logoImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      logoImageView.widthAnchor.constraint(equalToConstant: 55),
      logoImageView.heightAnchor.constraint(equalToConstant: 55),
      logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  private func configureStoreNameLabel() {
    storeNameLabel.font = .systemFont(ofSize: 16, weight: .bold)
    storeNameLabel.textAlignment = .left
    storeNameLabel.textColor = YDColors.black
    storeNameLabel.numberOfLines = 1
    storeNameLabel.layer.cornerRadius = 8
    addSubview(storeNameLabel)

    storeNameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      storeNameLabel.topAnchor.constraint(equalTo: topAnchor),
      storeNameLabel.leadingAnchor.constraint(
        equalTo: logoImageView.trailingAnchor,
        constant: 16
      ),
      storeNameLabel.trailingAnchor.constraint(
        equalTo: trailingAnchor
      ),
      storeNameLabel.heightAnchor.constraint(equalToConstant: 18)
    ])
  }

  private func configureAddressLabel() {
    addressLabel.font = .systemFont(ofSize: 14)
    addressLabel.textAlignment = .left
    addressLabel.textColor = YDColors.Gray.light
    addressLabel.numberOfLines = 2
    addressLabel.layer.cornerRadius = 8
    addSubview(addressLabel)

    addressLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      addressLabel.topAnchor.constraint(equalTo: storeNameLabel.bottomAnchor, constant: 3),
      addressLabel.leadingAnchor.constraint(equalTo: storeNameLabel.leadingAnchor),
      addressLabel.trailingAnchor.constraint(equalTo: storeNameLabel.trailingAnchor),
      addressLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 16)
    ])
  }
  
  private func configureAddressLabelShimmer() {
    addSubview(adressLabelShimmer)
    adressLabelShimmer.backgroundColor = .white
    adressLabelShimmer.layer.cornerRadius = 8
    adressLabelShimmer.isHidden = true

    adressLabelShimmer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      adressLabelShimmer.bottomAnchor.constraint(equalTo: bottomAnchor),
      adressLabelShimmer.leadingAnchor.constraint(equalTo: storeNameLabel.leadingAnchor),
      adressLabelShimmer.widthAnchor.constraint(equalToConstant: 90),
      adressLabelShimmer.heightAnchor.constraint(equalToConstant: 14)
    ])
  }
}
