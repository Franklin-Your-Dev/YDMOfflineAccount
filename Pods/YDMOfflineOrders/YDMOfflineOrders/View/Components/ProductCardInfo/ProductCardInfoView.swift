//
//  ProductCardInfoView.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 10/03/21.
//
import UIKit

import YDExtensions
import YDB2WAssets
import YDB2WModels
import YDB2WColors

// MARK: Product Info
class ProductCardInfoView: UIView {
  // MARK: Properties
  var photo = UIImageView()
  var photoMask = UIView()
  var name = UILabel()
  var badgeContainer = UIView()
  var badgeCount = UILabel()
  var phantomButton = UIButton()

  var currentProduct: YDOfflineOrdersProduct?

  // MARK: Init
  init() {
    super.init(frame: .zero)
    setUpLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Actions
  func config(with product: YDOfflineOrdersProduct) {
    currentProduct = product

    photo.setImage(product.image, placeholder: YDAssets.Icons.imagePlaceHolder)
    name.text = product.name?.lowercased()

    if product.howMany > 1 {
      badgeContainer.isHidden = false
      badgeCount.text = "\(product.howMany)"
    }
  }
}

// MARK: Layout
extension ProductCardInfoView {
  func setUpLayout() {
    heightAnchor.constraint(equalToConstant: 50).isActive = true

    createPhoto()
    createBadge()
    createName()
    createPhantomButton()
  }

  func createPhoto() {
    photo.contentMode = .scaleAspectFit
    photo.image = YDAssets.Icons.imagePlaceHolder
    photo.tintColor = YDColors.Gray.light
    photo.layer.cornerRadius = 8
    addSubview(photo)

    photo.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      photo.heightAnchor.constraint(equalToConstant: 36),
      photo.widthAnchor.constraint(equalToConstant: 36)
    ])

    photoMask.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
    photoMask.layer.opacity = 0.1
    photoMask.layer.cornerRadius = 8
    addSubview(photoMask)

    photoMask.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      photoMask.centerYAnchor.constraint(equalTo: centerYAnchor),
      photoMask.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: 16
      ),
      photoMask.heightAnchor.constraint(equalToConstant: 45),
      photoMask.widthAnchor.constraint(equalToConstant: 45)
    ])

    photo.centerYAnchor.constraint(equalTo: photoMask.centerYAnchor).isActive = true
    photo.centerXAnchor.constraint(equalTo: photoMask.centerXAnchor).isActive = true
  }

  func createBadge() {
    badgeContainer.backgroundColor = YDColors.branding
    badgeContainer.layer.cornerRadius = 8.5
    badgeContainer.isHidden = true
    addSubview(badgeContainer)

    badgeContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      badgeContainer.topAnchor.constraint(equalTo: photoMask.topAnchor, constant: -5),
      badgeContainer.trailingAnchor.constraint(equalTo: photoMask.trailingAnchor, constant: 5),
      badgeContainer.widthAnchor.constraint(equalToConstant: 17),
      badgeContainer.heightAnchor.constraint(equalToConstant: 17)
    ])

    badgeCount.textColor = YDColors.white
    badgeCount.textAlignment = .center
    badgeCount.font = .systemFont(ofSize: 13)
    badgeContainer.addSubview(badgeCount)

    badgeCount.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      badgeCount.leadingAnchor.constraint(equalTo: badgeContainer.leadingAnchor),
      badgeCount.trailingAnchor.constraint(equalTo: badgeContainer.trailingAnchor),
      badgeCount.topAnchor.constraint(equalTo: badgeContainer.topAnchor),
      badgeCount.bottomAnchor.constraint(equalTo: badgeContainer.bottomAnchor)
    ])
  }

  func createName() {
    name.font = .systemFont(ofSize: 14)
    name.textAlignment = .left
    name.textColor = YDColors.Gray.light
    name.numberOfLines = 2
    name.text = .lorem()
    addSubview(name)

    name.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      name.centerYAnchor.constraint(equalTo: photoMask.centerYAnchor),
      name.leadingAnchor.constraint(equalTo: photoMask.trailingAnchor, constant: 10),
      name.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      name.heightAnchor.constraint(greaterThanOrEqualToConstant: 14)
    ])
  }

  func createPhantomButton() {
    addSubview(phantomButton)

    phantomButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      phantomButton.topAnchor.constraint(equalTo: photoMask.topAnchor),
      phantomButton.leadingAnchor.constraint(equalTo: photoMask.leadingAnchor),
      phantomButton.trailingAnchor.constraint(equalTo: name.trailingAnchor),
      phantomButton.bottomAnchor.constraint(equalTo: photoMask.bottomAnchor)
    ])
  }
}
