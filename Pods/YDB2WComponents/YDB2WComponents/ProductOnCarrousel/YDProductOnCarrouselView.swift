//
//  YDProductOnCarrouselView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 24/10/21.
//

import UIKit
import YDB2WModels
import YDExtensions
import YDB2WColors
import Cosmos

class YDProductOnCarrouselView: UIView {
  // MARK: Properties
  var product: YDSpaceyProduct? {
    didSet {
      updateProduct()
    }
  }
  var callbackProductTap: (() -> Void)?
  var callbackAddToCartTap: (() -> Void)?
  var callbackCouponTap: (() -> Void)?
  
  // MARK: Components
  let containerView = UIView()
  let productImage = UIImageView()
  let productImageMaskImageView = UIView()
  
  let productTitleLabel = UILabel()
  
  var productRating = CosmosView()
  
  let productOldPriceLabel = UILabel()
  let productOldPriceDiscountTagContainer = UIView()
  let productOldPriceDiscountTagLabel = UILabel()
  
  let productPriceLabel = UILabel()
  
  let productPriceInstallmentLabel = UILabel()
  
  let addProductButton = YDWireButton(withTitle: "adicionar à cesta")
  
  let ticketView = UIView()
  let separatorViewsStack = UIStackView()
  let couponButton = UIButton(type: .system)
  
  // MARK: Life cycle
  func prepareView() {
    callbackProductTap = nil
    callbackCouponTap = nil
    callbackAddToCartTap = nil
    
    product = nil
    
    productImage.image = nil
    productTitleLabel.text = nil
    
    productRating.isHidden = true
    productRating.rating = 0
    productRating.text = ""
    
    productOldPriceDiscountTagContainer.isHidden = true
    productOldPriceLabel.text = nil
    
    productPriceLabel.text = nil
    
    productPriceInstallmentLabel.isHidden = true
    productPriceInstallmentLabel.text = nil
    
    setTicketView(hidden: true)
  }
  
  init() {
    super.init(frame: .zero)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Actions
extension YDProductOnCarrouselView {
  func configure(with product: YDSpaceyProduct?) {
    self.product = product
  }
  
  @objc func onCouponAction() {
    callbackCouponTap?()
  }
  
  func onAddToCartAction(_ sender: UIButton) {
    guard let product = self.product else { return }
    product.onBasket.toggle()
    
    changeAddToCartButtonStyle(with: product)
    callbackAddToCartTap?()
  }
  
  @objc func onProductTap() {
    callbackProductTap?()
  }
  
  private func updateProduct() {
    guard let product = product else {
      return
    }

    productImage.setImage(product.images?.first)

    changeAddToCartButtonStyle(with: product)

    if let name = product.name {
      productTitleLabel.text = name
    }

    if let price = product.price {
      productPriceLabel.text = price
    }
    
    if let rating = product.rating,
       rating.reviews >= 1 {
      productRating.rating = rating.average
      productRating.text = "\(rating.reviews)"
      productRating.isHidden = false

    } else {
      productRating.isHidden = true
    }

    if let priceFrom = product.priceFrom,
       let discountTagText = product.discountBadgeText {
      productOldPriceLabel.isHidden = false
      
      let attributeString = NSMutableAttributedString(string: priceFrom)
      attributeString.addAttribute(
        NSAttributedString.Key.strikethroughStyle,
        value: 2,
        range: NSMakeRange(0, attributeString.length)
      )
      productOldPriceLabel.attributedText = attributeString
      
      productOldPriceDiscountTagContainer.isHidden = false
      productOldPriceDiscountTagLabel.text = discountTagText
    } else {
      productOldPriceLabel.isHidden = true
      productOldPriceDiscountTagContainer.isHidden = true
    }

    if let priceConditions = product.priceConditions {
      productPriceInstallmentLabel.text = priceConditions
      productPriceInstallmentLabel.isHidden = false
    } else {
      productPriceInstallmentLabel.isHidden = true
    }
    
    if !product.productAvailable {
      setUnavailable()
    } else if product.onBasket {
      setOnBasket()
    } else {
      setAvailable()
    }
    
    guard product.hasCoupon else {
      setTicketView(hidden: true)
      return
    }

    setTicketView(hidden: false)
    
    if let title = product.couponName {
      let attributedString = NSAttributedString(
        string: title,
        attributes: [
          NSAttributedString.Key.foregroundColor: YDColors.white,
          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ]
      )
      
      couponButton.setAttributedTitle(attributedString, for: .normal)
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
  
  private func setTicketView(hidden: Bool) {
    if hidden {
      ticketView.isHidden = true
      containerView.layer.maskedCorners = [
        .layerMaxXMaxYCorner,
        .layerMaxXMinYCorner,
        .layerMinXMaxYCorner,
        .layerMinXMinYCorner
      ]
      containerView.layer.cornerRadius = 12
    } else {
      ticketView.isHidden = false
      containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      containerView.layer.cornerRadius = 12
    }
  }
}
