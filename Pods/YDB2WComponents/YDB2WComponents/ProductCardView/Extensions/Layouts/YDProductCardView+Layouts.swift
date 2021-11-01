//
//  YDProductCardView+Layouts.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 08/04/21.
//

import UIKit
import Cosmos

import YDExtensions
import YDB2WAssets
import YDB2WColors

// MARK: Layout
extension YDProductCardView {
  func setUpLayout() {
    createContainerView()
    createPhotoImageView()
    createProductNameLabel()

    if itsOnline {
      createBuyButton()
      createValueLabel()
      createShippingLabel()
    } else {
      createValueLabel()
      createRatingView()
    }

    // Shimmer
    createShimmerContainerView()
    createShimmerPhoto()
    createShimmerProductName()
    createShimmerRatingView()

    shimmers = [
      shimmerPhoto,
      shimmerProductName,
      shimmerProductRate,
      shimmerProductPrice
    ]
  }

  func createContainerView() {
    addSubview(container)

    container.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      container.topAnchor.constraint(equalTo: topAnchor),
      container.bottomAnchor.constraint(equalTo: bottomAnchor),
      container.leadingAnchor.constraint(equalTo: leadingAnchor),
      container.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }

  private func createPhotoImageView() {
    photoImageView.contentMode = .scaleAspectFit
    photoImageView.image = YDAssets.Icons.imagePlaceHolder
    photoImageView.tintColor = YDColors.Gray.light
    photoImageView.layer.cornerRadius = 8
    container.addSubview(photoImageView)

    photoImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      photoImageView.heightAnchor.constraint(equalToConstant: 70),
      photoImageView.widthAnchor.constraint(equalToConstant: 70)
    ])

    photoImageMask.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
    photoImageMask.layer.opacity = 0.1
    photoImageMask.layer.cornerRadius = 8
    container.addSubview(photoImageMask)

    photoImageMask.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      photoImageMask.centerYAnchor.constraint(equalTo: container.centerYAnchor),
      photoImageMask.leadingAnchor.constraint(
        equalTo: container.leadingAnchor,
        constant: 16
      ),
      photoImageMask.heightAnchor.constraint(equalToConstant: 80),
      photoImageMask.widthAnchor.constraint(equalToConstant: 80)
    ])

    photoImageView.centerYAnchor.constraint(equalTo: photoImageMask.centerYAnchor).isActive = true
    photoImageView.centerXAnchor.constraint(equalTo: photoImageMask.centerXAnchor).isActive = true
  }

  private func createProductNameLabel() {
    productNameLabel.font = .systemFont(ofSize: 14)
    productNameLabel.textAlignment = .left
    productNameLabel.textColor = YDColors.Gray.light
    productNameLabel.numberOfLines = 2
    container.addSubview(productNameLabel)

    productNameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productNameLabel.topAnchor.constraint(equalTo: photoImageMask.topAnchor),
      productNameLabel.leadingAnchor.constraint(
        equalTo: photoImageMask.trailingAnchor,
        constant: 16
      ),
      productNameLabel.trailingAnchor.constraint(
        equalTo: container.trailingAnchor,
        constant: -8
      )
    ])
  }

  private func createValueLabel() {
    productPriceLabel.font = .systemFont(ofSize: 24, weight: .bold)
    productPriceLabel.textAlignment = .left
    productPriceLabel.textColor = YDColors.black
    productPriceLabel.numberOfLines = 1
    container.addSubview(productPriceLabel)

    productPriceLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productPriceLabel.leadingAnchor.constraint(
        equalTo: photoImageMask.trailingAnchor,
        constant: 16
      ),
      productPriceLabel.heightAnchor.constraint(equalToConstant: 24)
    ])

    if itsOnline {
      productPriceLabel.topAnchor
        .constraint(equalTo: productNameLabel.bottomAnchor, constant: 10).isActive = true
      productPriceLabel.trailingAnchor
        .constraint(equalTo: buyButton.leadingAnchor, constant: -4).isActive = true
    } else {
      productPriceLabel.bottomAnchor
        .constraint(equalTo: photoImageMask.bottomAnchor).isActive = true
      productPriceLabel.trailingAnchor
        .constraint(equalTo: container.trailingAnchor, constant: -8).isActive = true
    }

    productPriceLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
  }

  private func createShippingLabel() {
    container.addSubview(shippingLabel)
    shippingLabel.font = .systemFont(ofSize: 13)
    shippingLabel.textColor = YDColors.Gray.light
    shippingLabel.textAlignment = .left
    shippingLabel.text = "consulte o valor do frete"
    shippingLabel.isHidden = true

    shippingLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shippingLabel.topAnchor.constraint(equalTo: productPriceLabel.bottomAnchor, constant: 6),
      shippingLabel.leadingAnchor
        .constraint(equalTo: photoImageMask.trailingAnchor, constant: 16),
      shippingLabel.trailingAnchor.constraint(equalTo: buyButton.leadingAnchor, constant: -4)
    ])
  }

  private func createBuyButton() {
    container.addSubview(buyButton)
    
    let attributedString = NSAttributedString(
      string: "comprar",
      attributes: [
        NSAttributedString.Key.foregroundColor: YDColors.branding,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium)
      ]
    )

    let attributedStringDisabled = NSAttributedString(
      string: "comprar",
      attributes: [
        NSAttributedString.Key.foregroundColor: YDColors.brandingHighlighted,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium)
      ]
    )

    buyButton.setAttributedTitle(attributedString, for: .normal)
    buyButton.setAttributedTitle(attributedStringDisabled, for: .disabled)
    buyButton.sizeToFit()
    
    buyButton.layer.borderWidth = 1.5
    buyButton.layer.borderColor = YDColors.branding.cgColor
    buyButton.layer.cornerRadius = 4
    buyButton.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      buyButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
      buyButton.widthAnchor.constraint(equalToConstant: 69),
      buyButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
      buyButton.heightAnchor.constraint(equalToConstant: 38)
    ])
  }

  private func createRatingView() {
    container.addSubview(ratingView)

    var settings = CosmosSettings()
    settings.emptyImage = YDAssets.Images.starGrey
    settings.filledImage = YDAssets.Images.starYellow
    settings.fillMode = .half
    settings.starMargin = 0
    settings.starSize = 12
    settings.totalStars = 5
    settings.textMargin = 6
    settings.textColor = YDColors.Gray.light
    settings.textFont = .systemFont(ofSize: 12)
    settings.updateOnTouch = false

    ratingView.settings = settings

    ratingView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      ratingView.topAnchor.constraint(
        greaterThanOrEqualTo: productNameLabel.bottomAnchor,
        constant: 4
      ),
      ratingView.leadingAnchor.constraint(
        equalTo: photoImageMask.trailingAnchor,
        constant: 16
      ),
      ratingView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
      ratingView.heightAnchor.constraint(equalToConstant: 13),
      ratingView.bottomAnchor.constraint(equalTo: productPriceLabel.topAnchor, constant: -5)
    ])

    ratingView.setContentHuggingPriority(.defaultLow, for: .vertical)
  }
}

// MARK: Shimmer
extension YDProductCardView {
  func createShimmerContainerView() {
    shimmerContainer.isHidden = true
    addSubview(shimmerContainer)

    shimmerContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerContainer.topAnchor.constraint(equalTo: topAnchor),
      shimmerContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
      shimmerContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
      shimmerContainer.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }

  func createShimmerPhoto() {
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
      shimmerPhoto.heightAnchor.constraint(equalToConstant: 80),
      shimmerPhoto.widthAnchor.constraint(equalToConstant: 80)
    ])
  }

  func createShimmerProductName() {
    shimmerProductName.backgroundColor = .white
    shimmerProductName.layer.cornerRadius = 4
    shimmerContainer.addSubview(shimmerProductName)

    shimmerProductName.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerProductName.topAnchor.constraint(equalTo: shimmerPhoto.topAnchor),
      shimmerProductName.leadingAnchor.constraint(
        equalTo: shimmerPhoto.trailingAnchor,
        constant: 16
      ),
      shimmerProductName.trailingAnchor.constraint(
        equalTo: shimmerContainer.trailingAnchor,
        constant: -8
      ),
      shimmerProductName.heightAnchor.constraint(equalToConstant: 13)
    ])
  }

  func createShimmerRatingView() {
    shimmerProductRate.backgroundColor = .white
    shimmerProductRate.layer.cornerRadius = 4
    shimmerContainer.addSubview(shimmerProductRate)

    shimmerProductRate.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerProductRate.topAnchor.constraint(
        equalTo: shimmerProductName.bottomAnchor,
        constant: 6
      ),
      shimmerProductRate.leadingAnchor.constraint(
        equalTo: photoImageMask.trailingAnchor,
        constant: 16
      ),
      shimmerProductRate.trailingAnchor.constraint(
        equalTo: container.trailingAnchor,
        constant: -8
      ),
      shimmerProductRate.heightAnchor.constraint(equalToConstant: 13)
    ])
  }

  func createShimmerProductPrice() {
    shimmerProductPrice.backgroundColor = .white
    shimmerProductPrice.layer.cornerRadius = 4
    shimmerContainer.addSubview(shimmerProductPrice)

    shimmerProductPrice.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerProductPrice.bottomAnchor.constraint(equalTo: shimmerPhoto.bottomAnchor),
      shimmerProductPrice.leadingAnchor.constraint(
        equalTo: shimmerPhoto.trailingAnchor,
        constant: 16
      ),
      shimmerProductPrice.trailingAnchor.constraint(
        equalTo: shimmerContainer.trailingAnchor,
        constant: -108
      ),
      shimmerProductPrice.heightAnchor.constraint(equalToConstant: 13)
    ])
  }
}
