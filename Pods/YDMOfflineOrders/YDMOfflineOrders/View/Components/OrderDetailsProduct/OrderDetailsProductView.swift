//
//  OrderDetailsProductView.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 12/03/21.
//
import UIKit

import YDExtensions
import YDB2WAssets
import YDB2WModels
import YDB2WColors

class OrderDetailsProductView: UIView {
  // MARK: Components
  let container = UIView()
  let howManyContainer = UIView()
  let howManyLabel = UILabel()
  let nameLabel = UILabel()
  let priceLabel = UILabel()

  let shimmerContainer = UIView()
  let shimmerPhoto = UIView()
  let shimmerName = UIView()
  let shimmerPrice = UIView()

  // MARK: Init
  init() {
    super.init(frame: .zero)

    backgroundColor = .clear
    layer.masksToBounds = false

    translatesAutoresizingMaskIntoConstraints = true
    heightAnchor.constraint(equalToConstant: 40).isActive = true

    setUpLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Actions
  func prepareForUse() {
    nameLabel.text = nil
    priceLabel.text = nil
    container.isHidden = true
    shimmerContainer.isHidden = false
    shimmerPhoto.stopShimmer()
    shimmerName.stopShimmer()
    shimmerPrice.stopShimmer()
  }

  func config(with product: YDOfflineOrdersProduct) {
    container.isHidden = false
    shimmerContainer.isHidden = true

    nameLabel.text = product.name?.lowercased()
    priceLabel.text = product.formatedPrice
    howManyLabel.text = "\(product.howMany)"
  }
}

// MARK: Layout
extension OrderDetailsProductView {
  func setUpLayout() {
    configureContainer()
    configureHowMany()
    configureNameLabel()
    configurePrice()

    // Shimmer
    configureShimmerContainer()
    configureShimmerHowMany()
    configureShimmerName()
    configureShimmerPrice()
  }

  func configureContainer() {
    addSubview(container)

    container.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      container.topAnchor.constraint(equalTo: topAnchor),
      container.bottomAnchor.constraint(equalTo: bottomAnchor),
      container.leadingAnchor.constraint(equalTo: leadingAnchor),
      container.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }

  func configureHowMany() {
    container.addSubview(howManyContainer)
    howManyContainer.backgroundColor = YDColors.Gray.night
    howManyContainer.layer.cornerRadius = 8

    howManyContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      howManyContainer.centerYAnchor.constraint(equalTo: container.centerYAnchor),
      howManyContainer.leadingAnchor.constraint(
        equalTo: container.leadingAnchor,
        constant: 16
      ),
      howManyContainer.heightAnchor.constraint(equalToConstant: 40),
      howManyContainer.widthAnchor.constraint(equalToConstant: 40)
    ])
    
    // Label
    howManyContainer.addSubview(howManyLabel)
    howManyLabel.font = .boldSystemFont(ofSize: 16)
    howManyLabel.textColor = YDColors.black
    howManyLabel.textAlignment = .center
    
    howManyLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      howManyLabel.centerXAnchor.constraint(equalTo: howManyContainer.centerXAnchor),
      howManyLabel.centerYAnchor.constraint(equalTo: howManyContainer.centerYAnchor)
    ])
  }

  func configureNameLabel() {
    container.addSubview(nameLabel)
    nameLabel.font = .systemFont(ofSize: 14)
    nameLabel.textAlignment = .left
    nameLabel.textColor = YDColors.Gray.light
    nameLabel.numberOfLines = 2

    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      nameLabel.leadingAnchor.constraint(
        equalTo: howManyContainer.trailingAnchor,
        constant: 16
      ),
      nameLabel.centerYAnchor.constraint(equalTo: howManyContainer.centerYAnchor),
      nameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 16)
    ])
    
    NSLayoutConstraint(
      item: nameLabel,
      attribute: .trailing,
      relatedBy: .equal,
      toItem: container,
      attribute: .centerX,
      multiplier: 1.2,
      constant: 10
    ).isActive = true
  }

  func configurePrice() {
    container.addSubview(priceLabel)
    priceLabel.font = .boldSystemFont(ofSize: 14)
    priceLabel.textAlignment = .left
    priceLabel.textColor = YDColors.black

    priceLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      priceLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
      priceLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
      priceLabel.heightAnchor.constraint(equalToConstant: 16)
    ])
  }

  // Shimmer
  func configureShimmerContainer() {
    addSubview(shimmerContainer)

    shimmerContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerContainer.topAnchor.constraint(equalTo: topAnchor),
      shimmerContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
      shimmerContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
      shimmerContainer.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }

  func configureShimmerHowMany() {
    shimmerPhoto.backgroundColor = .white
    shimmerPhoto.layer.cornerRadius = 8
    shimmerContainer.addSubview(shimmerPhoto)

    shimmerPhoto.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerPhoto.centerYAnchor.constraint(equalTo: shimmerContainer.centerYAnchor),
      shimmerPhoto.leadingAnchor.constraint(
        equalTo: shimmerContainer.leadingAnchor,
        constant: 16
      ),
      shimmerPhoto.heightAnchor.constraint(equalToConstant: 45),
      shimmerPhoto.widthAnchor.constraint(equalToConstant: 45)
    ])
  }

  func configureShimmerName() {
    shimmerName.backgroundColor = .white
    shimmerName.layer.cornerRadius = 8
    shimmerContainer.addSubview(shimmerName)

    shimmerName.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerName.topAnchor.constraint(equalTo: shimmerPhoto.topAnchor, constant: 7),
      shimmerName.leadingAnchor.constraint(equalTo: shimmerPhoto.trailingAnchor, constant: 16),
      shimmerName.trailingAnchor.constraint(
        equalTo: shimmerContainer.trailingAnchor,
        constant: -24
      ),
      shimmerName.heightAnchor.constraint(equalToConstant: 13)
    ])
  }

  func configureShimmerPrice() {
    shimmerPrice.backgroundColor = .white
    shimmerPrice.layer.cornerRadius = 8
    shimmerContainer.addSubview(shimmerPrice)

    shimmerPrice.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerPrice.topAnchor.constraint(equalTo: shimmerName.bottomAnchor, constant: 6),
      shimmerPrice.leadingAnchor.constraint(
        equalTo: shimmerPhoto.trailingAnchor,
        constant: 16
      ),
      shimmerPrice.widthAnchor.constraint(equalToConstant: 80),
      shimmerPrice.heightAnchor.constraint(equalToConstant: 13)
    ])
  }
}
