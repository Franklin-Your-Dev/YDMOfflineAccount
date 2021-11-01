//
//  YDProductOnCarrouselView+Layout.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 25/10/21.
//

import UIKit
import YDExtensions
import YDB2WAssets
import YDB2WColors
import Cosmos

extension YDProductOnCarrouselView {
  func configureUI() {
    configureSelfView()
    
    configureContainerView()
    
    configurePhotoImageView()
    
    configureProductTitleLabel()
    
    configureProductRatingView()
    
    configureProductOldPriceLabel()
    configureProductOldPriceTagContainer()
    configureProductOldPriceDiscountTagLabel()
    
    configureProductPriceLabel()
    
    configureProductPriceInstallmentLabel()
    
    configureAddToCartButton()
    
    configureTicketView()
    configureSeparatorViews()
    configureCouponButton()
  }
  
  private func configureSelfView() {
    // layer.masksToBounds = true
    
    addGestureRecognizer(
      UITapGestureRecognizer(target: self, action: #selector(onProductTap))
    )
    
    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      widthAnchor.constraint(equalToConstant: 175),
      heightAnchor.constraint(equalToConstant: 374)
    ])
  }
  
  private func configureContainerView() {
    addSubview(containerView)
    containerView.backgroundColor = .white
    containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    containerView.layer.cornerRadius = 12
    containerView.layer.applyShadow()
    
    containerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: topAnchor),
      containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
      containerView.heightAnchor.constraint(equalToConstant: 308)
    ])
  }
}

// MARK: Photo
extension YDProductOnCarrouselView {
  private func configurePhotoImageView() {
    containerView.addSubview(productImage)
    productImage.contentMode = .scaleAspectFill
    
    productImage.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
      productImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      productImage.widthAnchor.constraint(equalToConstant: 100),
      productImage.heightAnchor.constraint(equalToConstant: 100)
    ])
    
    //
    containerView.addSubview(productImageMaskImageView)
    productImageMaskImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
    productImageMaskImageView.layer.opacity = 0.1
    productImageMaskImageView.layer.cornerRadius = 12
    productImageMaskImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    
    productImageMaskImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productImageMaskImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
      productImageMaskImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      productImageMaskImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      productImageMaskImageView.heightAnchor.constraint(equalToConstant: 120)
    ])
  }
}

// MARK: Product Title
extension YDProductOnCarrouselView {
  private func configureProductTitleLabel() {
    containerView.addSubview(productTitleLabel)
    productTitleLabel.font = .systemFont(ofSize: 12, weight: .medium)
    productTitleLabel.textColor = YDColors.black
    productTitleLabel.textAlignment = .left
    productTitleLabel.numberOfLines = 2
    
    productTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productTitleLabel.topAnchor.constraint(
        equalTo: productImageMaskImageView.bottomAnchor,
        constant: 12
      ),
      productTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
      productTitleLabel.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor,
        constant: -12
      ),
      productTitleLabel.heightAnchor.constraint(equalToConstant: 32)
    ])
  }
}

// MARK: Product Rating
extension YDProductOnCarrouselView {
  private func configureProductRatingView() {
    containerView.addSubview(productRating)
    productRating.settings.emptyImage = YDAssets.Images.starGrey
    productRating.settings.filledImage = YDAssets.Images.starYellow
    productRating.settings.fillMode = .half
    productRating.settings.starMargin = 0
    productRating.settings.starSize = 12
    productRating.settings.totalStars = 5
    productRating.settings.textFont = .systemFont(ofSize: 12)
    productRating.settings.textColor = YDColors.Gray.light
    productRating.settings.updateOnTouch = false
    
    productRating.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productRating.topAnchor.constraint(
        equalTo: productTitleLabel.bottomAnchor,
        constant: 8
      ),
      productRating.heightAnchor.constraint(equalToConstant: 14),
      productRating.leadingAnchor.constraint(equalTo: productTitleLabel.leadingAnchor)
    ])
  }
}

// MARK: Product Old Price
extension YDProductOnCarrouselView {
  private func configureProductOldPriceLabel() {
    containerView.addSubview(productOldPriceLabel)
    productOldPriceLabel.isHidden = true
    productOldPriceLabel.textColor = YDColors.Gray.light
    productOldPriceLabel.textAlignment = .left
    productOldPriceLabel.font = .systemFont(ofSize: 12)
    
    productOldPriceLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productOldPriceLabel.topAnchor.constraint(
        equalTo: productRating.bottomAnchor,
        constant: 8
      ),
      productOldPriceLabel.leadingAnchor.constraint(equalTo: productTitleLabel.leadingAnchor),
      productOldPriceLabel.heightAnchor.constraint(equalToConstant: 14)
    ])
  }
  
  private func configureProductOldPriceTagContainer() {
    containerView.addSubview(productOldPriceDiscountTagContainer)
    productOldPriceDiscountTagContainer.isHidden = true
    productOldPriceDiscountTagContainer.backgroundColor = YDColors.Green.done
    productOldPriceDiscountTagContainer.layer.cornerRadius = 7
    
    productOldPriceDiscountTagContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productOldPriceDiscountTagContainer.centerYAnchor.constraint(
        equalTo: productOldPriceLabel.centerYAnchor
      ),
      productOldPriceDiscountTagContainer.leadingAnchor.constraint(
        equalTo: productOldPriceLabel.trailingAnchor,
        constant: 10
      ),
      productOldPriceDiscountTagContainer.heightAnchor.constraint(equalToConstant: 14)
    ])
  }
  
  private func configureProductOldPriceDiscountTagLabel() {
    let pointerIcon = UIImageView()
    pointerIcon.image = YDAssets.Icons.arrowDown
    pointerIcon.tintColor = YDColors.white
    productOldPriceDiscountTagContainer.addSubview(pointerIcon)
    
    pointerIcon.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      pointerIcon.centerYAnchor.constraint(
        equalTo: productOldPriceDiscountTagContainer.centerYAnchor
      ),
      pointerIcon.widthAnchor.constraint(equalToConstant: 8),
      pointerIcon.heightAnchor.constraint(equalToConstant: 8),
      pointerIcon.leadingAnchor.constraint(
        equalTo: productOldPriceDiscountTagContainer.leadingAnchor,
        constant: 6
      )
    ])
    
    productOldPriceDiscountTagContainer.addSubview(productOldPriceDiscountTagLabel)
    productOldPriceDiscountTagLabel.font = .boldSystemFont(ofSize: 8)
    productOldPriceDiscountTagLabel.textColor = YDColors.white
    
    productOldPriceDiscountTagLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productOldPriceDiscountTagLabel.centerYAnchor.constraint(
        equalTo: productOldPriceDiscountTagContainer.centerYAnchor
      ),
      productOldPriceDiscountTagLabel.leadingAnchor.constraint(
        equalTo: pointerIcon.trailingAnchor,
        constant: 4
      ),
      productOldPriceDiscountTagLabel.trailingAnchor.constraint(
        equalTo: productOldPriceDiscountTagContainer.trailingAnchor,
        constant: -6
      )
    ])
  }
}

// MARK: Product Price
extension YDProductOnCarrouselView {
  private func configureProductPriceLabel() {
    containerView.addSubview(productPriceLabel)
    productPriceLabel.font = .boldSystemFont(ofSize: 14)
    productPriceLabel.textColor = YDColors.black
    productPriceLabel.textAlignment = .left
    
    productPriceLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productPriceLabel.topAnchor.constraint(
        equalTo: productOldPriceLabel.bottomAnchor,
        constant: 2
      ),
      productPriceLabel.leadingAnchor.constraint(equalTo: productTitleLabel.leadingAnchor),
      productPriceLabel.heightAnchor.constraint(equalToConstant: 18)
    ])
  }
}

// MARK: Product Price Installment
extension YDProductOnCarrouselView {
  private func configureProductPriceInstallmentLabel() {
    containerView.addSubview(productPriceInstallmentLabel)
    productPriceInstallmentLabel.isHidden = true
    productPriceInstallmentLabel.font = .systemFont(ofSize: 12)
    productPriceInstallmentLabel.textColor = YDColors.Gray.light
    productPriceInstallmentLabel.textAlignment = .left
    
    productPriceInstallmentLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productPriceInstallmentLabel.topAnchor.constraint(
        equalTo: productPriceLabel.bottomAnchor
      ),
      productPriceInstallmentLabel.leadingAnchor.constraint(
        equalTo: productTitleLabel.leadingAnchor
      ),
      productPriceInstallmentLabel.trailingAnchor.constraint(
        equalTo: productTitleLabel.trailingAnchor
      ),
      productPriceInstallmentLabel.heightAnchor.constraint(equalToConstant: 14)
    ])
  }
}

// MARK: Add to Cart Button
extension YDProductOnCarrouselView {
  private func configureAddToCartButton() {
    containerView.addSubview(addProductButton)
    
    addProductButton.callback = onAddToCartAction
    
    NSLayoutConstraint.activate([
      addProductButton.topAnchor.constraint(
        equalTo: productPriceInstallmentLabel.bottomAnchor, constant: 16
      ),
      addProductButton.leadingAnchor.constraint(
        equalTo: containerView.leadingAnchor,
        constant: 12
      ),
      addProductButton.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor,
        constant: -12
      )
    ])
  }
}

// MARK: Ticket View
extension YDProductOnCarrouselView {
  private func configureTicketView() {
    addSubview(ticketView)
    ticketView.backgroundColor = .white
    ticketView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    ticketView.layer.cornerRadius = 12
    ticketView.layer.applyShadow()
    
    ticketView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      ticketView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
      ticketView.leadingAnchor.constraint(equalTo: leadingAnchor),
      ticketView.trailingAnchor.constraint(equalTo: trailingAnchor),
      ticketView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)
    ])
  }
}

// MARK: Separator Views
extension YDProductOnCarrouselView {
  private func configureSeparatorViews() {
    // 14
    ticketView.addSubview(separatorViewsStack)
    separatorViewsStack.alignment = .fill
    separatorViewsStack.axis = .horizontal
    separatorViewsStack.distribution = .fillEqually
    separatorViewsStack.spacing = 4
    
    separatorViewsStack.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      separatorViewsStack.topAnchor.constraint(equalTo: ticketView.topAnchor, constant: 8),
      separatorViewsStack.leadingAnchor.constraint(
        equalTo: ticketView.leadingAnchor,
        constant: 18
      ),
      separatorViewsStack.trailingAnchor.constraint(
        equalTo: ticketView.trailingAnchor,
        constant: -18
      ),
      separatorViewsStack.heightAnchor.constraint(equalToConstant: 1)
    ])
    
    // Add Views
    for _ in 1...14 {
      let currView = UIView()
      currView.backgroundColor = YDColors.Gray.night
      currView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        currView.heightAnchor.constraint(equalToConstant: 1)
      ])
      separatorViewsStack.addArrangedSubview(currView)
    }
  }
}

// MARK: Coupon Button
extension YDProductOnCarrouselView {
  private func configureCouponButton() {
    ticketView.addSubview(couponButton)
    couponButton.setTitle("", for: .normal)
    couponButton.setTitleColor(YDColors.white, for: .normal)
    couponButton.backgroundColor = YDColors.branding
    couponButton.layer.cornerRadius = 12
    couponButton.layer.applyShadow()
    
    couponButton.addTarget(self, action: #selector(onCouponAction), for: .touchUpInside)
    
    couponButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      couponButton.topAnchor.constraint(equalTo: separatorViewsStack.bottomAnchor, constant: 16),
      couponButton.leadingAnchor.constraint(equalTo: ticketView.leadingAnchor, constant: 16),
      couponButton.trailingAnchor.constraint(equalTo: ticketView.trailingAnchor, constant: -16),
      couponButton.heightAnchor.constraint(equalToConstant: 24)
    ])
  }
}
