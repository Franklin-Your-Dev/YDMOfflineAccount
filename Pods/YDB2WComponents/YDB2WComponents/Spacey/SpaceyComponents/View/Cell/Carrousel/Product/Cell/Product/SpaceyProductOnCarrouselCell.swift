//
//  SpaceyProductOnCarrouselCell.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 26/10/21.
//

import UIKit

import UIKit
import Cosmos
import YDExtensions
import YDB2WAssets
import YDB2WModels
import YDUtilities
import YDB2WColors

class SpaceyProductOnCarrouselCell: UICollectionViewCell {
  // MARK: Properties
  var product: YDSpaceyProduct?
  
  var callbackProductTap: (() -> Void)?
  var callbackAddToCartTap: (() -> Void)?
  
  // MARK: Components
  let productImage = UIImageView()
  let productImageMaskImageView = UIView()
  let productTitleLabel = UILabel()
  let addProductButton = YDWireButton(withTitle: "adicionar à cesta")
  let priceInstallmentLabel = UILabel()
  let priceLabel = UILabel()
  let priceOneTimeLabel = UILabel()
  var productRate = CosmosView()
  
  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    
    contentView.addGestureRecognizer(
      UITapGestureRecognizer(target: self, action: #selector(onProductTap))
    )
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Life cycle
  override func prepareForReuse() {
    callbackProductTap = nil
    product = nil
    productImage.image = nil
    productTitleLabel.text = nil
    priceLabel.text = nil

    priceInstallmentLabel.text = nil
    priceInstallmentLabel.isHidden = false

    productRate.rating = 0
    productRate.text = ""
    productRate.isHidden = false
    super.prepareForReuse()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    contentView.layer.applyShadow(alpha: 0.08, y: 6, blur: 20, spread: -1)
    contentView.layer.shadowPath = UIBezierPath(
      roundedRect: contentView.bounds,
      cornerRadius: 6
    ).cgPath
  }

  // MARK: Config
  func config(with product: YDSpaceyProduct) {
    self.product = product
    applyProduct()
  }
}

// MARK: Actions
extension SpaceyProductOnCarrouselCell {
  func onProductButtonAction() {
    guard let product = self.product else { return }
    product.onBasket.toggle()
    
    changeAddToCartButtonStyle(with: product)
    callbackAddToCartTap?()
  }
  
  @objc func onProductTap() {
    callbackProductTap?()
  }
  
  private func applyProduct() {
    guard let product = product else {
      return
    }

    productImage.setImage(product.images?.first)
    productImage.layer.cornerRadius = 6
    productImageMaskImageView.layer.cornerRadius = 6

    changeAddToCartButtonStyle(with: product)

    if let name = product.name {
      productTitleLabel.text = name
    }

    if let price = product.price {
      priceLabel.text = price
    }

    if let priceFrom = product.priceFrom {
      priceOneTimeLabel.isHidden = false
      priceOneTimeLabel.text = priceFrom
    } else {
      priceOneTimeLabel.isHidden = true
    }

    if let priceConditions = product.priceConditions {
      priceInstallmentLabel.text = priceConditions
      priceInstallmentLabel.isHidden = false
    } else {
      priceInstallmentLabel.isHidden = true
    }

    if let rating = product.rating,
       rating.reviews >= 1 {
      productRate.rating = rating.average
      productRate.text = "\(rating.reviews) \(rating.reviews > 1 ? "avaliações" : "avaliação")"
      productRate.isHidden = false

    } else {
      productRate.isHidden = true
    }

    if !product.productAvailable {
      setUnavailable()
    } else if product.onBasket {
      setOnBasket()
    } else {
      setAvailable()
    }
  }

  private func changeAddToCartButtonStyle(with product: YDSpaceyProduct) {
    product.onBasket ? setOnBasket() : setAvailable()
  }

  private func setAvailable() {
    addProductButton.setEnabled(true)
    addProductButton.setTitle("adicionar à cesta", for: .normal, withColor: YDColors.branding)
    addProductButton.backgroundColor = YDColors.white
  }

  private func setOnBasket() {
    addProductButton.setEnabled(false)
    addProductButton.setTitle(
      "adicionado",
      for: .disabled,
      withColor: YDColors.brandingHighlighted
    )
    addProductButton.backgroundColor = YDColors.white
  }

  private func setUnavailable() {
    addProductButton.setEnabled(false)
    addProductButton.setTitle("indisponível", for: .disabled, withColor: YDColors.Gray.medium)
    addProductButton.backgroundColor = YDColors.Gray.night
    
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.addProductButton.layer.borderColor = YDColors.Gray.night.cgColor
    }
  }
}
