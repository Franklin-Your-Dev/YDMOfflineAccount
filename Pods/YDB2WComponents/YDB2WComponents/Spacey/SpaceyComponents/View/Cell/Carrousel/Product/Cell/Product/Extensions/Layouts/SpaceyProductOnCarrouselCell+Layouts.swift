//
//  SpaceyProductOnCarrouselCell+Layouts.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 26/10/21.
//

import UIKit
import YDExtensions
import YDB2WAssets
import YDB2WColors

extension SpaceyProductOnCarrouselCell {
  func configureUI() {
    contentView.backgroundColor = .white
    contentView.layer.cornerRadius = 6
    
    configureProductImage()
    configureProductTitleLabel()
    
    configureAddButton()
    
    configurePriceInstallmentLabel()
    configurePriceLabel()
    configurePriceOneTimeLabel()
    
    configureRateView()
  }
  
  private func configureProductImage() {
    contentView.addSubview(productImage)
    productImage.contentMode = .scaleAspectFill
    productImage.layer.cornerRadius = 6
    
    productImage.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
      productImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
      productImage.widthAnchor.constraint(equalToConstant: 116),
      productImage.heightAnchor.constraint(equalToConstant: 116)
    ])
    
    // Mask
    contentView.addSubview(productImageMaskImageView)
    productImageMaskImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
    productImageMaskImageView.layer.opacity = 0.1
    productImageMaskImageView.layer.cornerRadius = 6
    
    productImageMaskImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productImageMaskImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
      productImageMaskImageView.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor,
        constant: 12
      ),
      productImageMaskImageView.widthAnchor.constraint(equalToConstant: 116),
      productImageMaskImageView.heightAnchor.constraint(equalToConstant: 116)
    ])
  }
  
  private func configureProductTitleLabel() {
    contentView.addSubview(productTitleLabel)
    productTitleLabel.font = .systemFont(ofSize: 14)
    productTitleLabel.textColor = YDColors.Gray.light
    productTitleLabel.textAlignment = .left
    productTitleLabel.numberOfLines = 2
    
    productTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
      productTitleLabel.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 8),
      productTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
    ])
  }
  
  private func configureAddButton() {
    contentView.addSubview(addProductButton)
    
    addProductButton.callback = { [weak self] _ in
      guard let self = self else { return }
      self.onProductButtonAction()
    }
    
    NSLayoutConstraint.activate([
      addProductButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
      addProductButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
      addProductButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
    ])
  }
  
  private func configurePriceInstallmentLabel() {
    contentView.addSubview(priceInstallmentLabel)
    priceInstallmentLabel.font = .systemFont(ofSize: 12)
    priceInstallmentLabel.textColor = YDColors.black
    priceInstallmentLabel.textAlignment = .left
    
    priceInstallmentLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      priceInstallmentLabel.bottomAnchor.constraint(
        equalTo: addProductButton.topAnchor,
        constant: -18
      ),
      priceInstallmentLabel.leadingAnchor.constraint(equalTo: productTitleLabel.leadingAnchor),
      priceInstallmentLabel.trailingAnchor.constraint(equalTo: productTitleLabel.trailingAnchor),
      priceInstallmentLabel.heightAnchor.constraint(equalToConstant: 14)
    ])
  }
  
  private func configurePriceLabel() {
    contentView.addSubview(priceLabel)
    priceLabel.font = .boldSystemFont(ofSize: 16)
    priceLabel.textColor = YDColors.black
    priceLabel.textAlignment = .left
    
    priceLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      priceLabel.bottomAnchor.constraint(
        equalTo: priceInstallmentLabel.topAnchor,
        constant: -4
      ),
      priceLabel.leadingAnchor.constraint(equalTo: productTitleLabel.leadingAnchor),
      priceLabel.trailingAnchor.constraint(equalTo: productTitleLabel.trailingAnchor),
      priceLabel.heightAnchor.constraint(equalToConstant: 18)
    ])
  }
  
  private func configurePriceOneTimeLabel() {
    contentView.addSubview(priceOneTimeLabel)
    priceOneTimeLabel.font = .systemFont(ofSize: 12)
    priceOneTimeLabel.textColor = YDColors.Gray.light
    priceOneTimeLabel.textAlignment = .left
    
    priceOneTimeLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      priceOneTimeLabel.bottomAnchor.constraint(
        equalTo: priceLabel.topAnchor,
        constant: -4
      ),
      priceOneTimeLabel.leadingAnchor.constraint(equalTo: productTitleLabel.leadingAnchor),
      priceOneTimeLabel.trailingAnchor.constraint(equalTo: productTitleLabel.trailingAnchor),
      priceOneTimeLabel.heightAnchor.constraint(equalToConstant: 14)
    ])
  }
  
  private func configureRateView() {
    contentView.addSubview(productRate)
    productRate.settings.emptyImage = YDAssets.Images.starGrey
    productRate.settings.filledImage = YDAssets.Images.starYellow
    productRate.settings.fillMode = .half
    productRate.settings.starMargin = 0
    productRate.settings.starSize = 12
    productRate.settings.totalStars = 5
    
    productRate.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productRate.bottomAnchor.constraint(
        equalTo: priceOneTimeLabel.topAnchor,
        constant: -12
      ),
      productRate.leadingAnchor.constraint(equalTo: productTitleLabel.leadingAnchor),
      productRate.trailingAnchor.constraint(equalTo: productTitleLabel.trailingAnchor),
      productRate.heightAnchor.constraint(equalToConstant: 14)
    ])
  }
}
