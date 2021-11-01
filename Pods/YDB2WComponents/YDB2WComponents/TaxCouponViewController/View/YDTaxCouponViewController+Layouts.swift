//
//  YDTaxCouponViewController+Layouts.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 25/08/21.
//

import UIKit
import YDExtensions
import YDB2WAssets
import YDB2WColors

extension YDTaxCouponViewController {
  func configureUI() {
    configureView()
    configureContainerView()
    
    configureTopViews()
    configureMiddleViews()
    configureBottomViews()
    configureShare()
  }
  
  private func configureView() {
    view.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      view.widthAnchor.constraint(equalToConstant: 320)
    ])
    
    viewHeight = view.heightAnchor.constraint(equalToConstant: 550)
    viewHeight.isActive = true
  }
  
  private func configureContainerView() {
    view.addSubview(containerView)
    containerView.backgroundColor = YDColors.Gray.opaque
    containerView.layer.cornerRadius = 12
    containerView.layer.applyShadow()
    containerView.clipsToBounds = true
    
    containerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: view.topAnchor),
      containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      containerView.widthAnchor.constraint(equalToConstant: 320)
    ])
    containerViewHeightConstraint.isActive = true
  }
}

// MARK: ContainerView Top
extension YDTaxCouponViewController {
  private func configureTopViews() {
    configureBackButton()
    
    configureLogoImageView()
    
    configureStoreNameLabel()
    configureStoreAddressLabel()
    
    configureStoreSeparatorView()
  }
  
  private func configureBackButton() {
    containerView.addSubview(backButton)
    backButton.tintColor = labelsColor
    backButton.setImage(YDAssets.Icons.times, for: .normal)
    
    backButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      backButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
      backButton.trailingAnchor
        .constraint(equalTo: containerView.trailingAnchor, constant: -8),
      backButton.widthAnchor.constraint(equalToConstant: 30),
      backButton.heightAnchor.constraint(equalToConstant: 30)
    ])
    
    backButton.addTarget(self, action: #selector(onBackAction), for: .touchUpInside)
  }
  
  private func configureLogoImageView() {
    containerView.addSubview(logoImageView)
    logoImageView.tintColor = labelsColor
    logoImageView.image = YDAssets.Icons.logoSmall
    
    logoImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      logoImageView.topAnchor
        .constraint(equalTo: containerView.topAnchor, constant: 29),
      logoImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      logoImageView.widthAnchor.constraint(equalToConstant: 130),
      logoImageView.heightAnchor.constraint(equalToConstant: 24)
    ])
    logoImageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
  }
  
  private func configureStoreNameLabel() {
    containerView.addSubview(storeNameLabel)
    storeNameLabel.textColor = labelsColor
    storeNameLabel.font = .boldSystemFont(ofSize: 16)
    storeNameLabel.textAlignment = .center
    
    storeNameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      storeNameLabel.topAnchor
        .constraint(equalTo: logoImageView.bottomAnchor, constant: 12),
      storeNameLabel.leadingAnchor
        .constraint(equalTo: containerView.leadingAnchor, constant: containerPadding),
      storeNameLabel.trailingAnchor
        .constraint(equalTo: containerView.trailingAnchor, constant: -containerPadding)
    ])
  }
  
  private func configureStoreAddressLabel() {
    containerView.addSubview(storeAddressLabel)
    storeAddressLabel.textColor = labelsColor
    storeAddressLabel.font = .systemFont(ofSize: 13)
    storeAddressLabel.textAlignment = .center
    storeAddressLabel.numberOfLines = 2
    
    storeAddressLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      storeAddressLabel.topAnchor.constraint(
        equalTo: storeNameLabel.bottomAnchor,
        constant: 12
      ),
      storeAddressLabel.leadingAnchor.constraint(
        equalTo: containerView.leadingAnchor,
        constant: addressPadding
      ),
      storeAddressLabel.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor,
        constant: -addressPadding
      )
    ])
  }
  
  private func configureStoreSeparatorView() {
    containerView.addSubview(storeSeparatorView)
    storeSeparatorView.backgroundColor = separatorViewColor
    
    storeSeparatorView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      storeSeparatorView.topAnchor
        .constraint(equalTo: storeAddressLabel.bottomAnchor, constant: 16),
      storeSeparatorView.leadingAnchor
        .constraint(equalTo: containerView.leadingAnchor),
      storeSeparatorView.trailingAnchor
        .constraint(equalTo: containerView.trailingAnchor),
      storeSeparatorView.heightAnchor.constraint(equalToConstant: 1)
    ])
  }
}

// MARK: ContainerView Middle
extension YDTaxCouponViewController {
  private func configureMiddleViews() {
    configureDateInfoView()
    configureStoreInfoView()
    configurePDVInfoView()
    configureCouponInfoView()
    
    configureTaxCouponLabel()
    configureTaxCouponLabelSeparatorView()
  }
  
  private func configureDateInfoView() {
    containerView.addSubview(dateInfoView)
    NSLayoutConstraint.activate([
      dateInfoView.topAnchor
        .constraint(equalTo: storeSeparatorView.bottomAnchor, constant: 12),
      dateInfoView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: containerPadding),
      dateInfoView.trailingAnchor
        .constraint(equalTo: containerView.trailingAnchor, constant: -containerPadding)
    ])
  }
  
  private func configureStoreInfoView() {
    containerView.addSubview(storeInfoView)
    NSLayoutConstraint.activate([
      storeInfoView.topAnchor
        .constraint(equalTo: dateInfoView.bottomAnchor, constant: 3),
      storeInfoView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: containerPadding),
      storeInfoView.trailingAnchor
        .constraint(equalTo: containerView.trailingAnchor, constant: -containerPadding)
    ])
  }
  
  private func configurePDVInfoView() {
    containerView.addSubview(PDVInfoView)
    NSLayoutConstraint.activate([
      PDVInfoView.topAnchor
        .constraint(equalTo: storeInfoView.bottomAnchor, constant: 3),
      PDVInfoView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: containerPadding),
      PDVInfoView.trailingAnchor
        .constraint(equalTo: containerView.trailingAnchor, constant: -containerPadding)
    ])
  }
  
  private func configureCouponInfoView() {
    containerView.addSubview(couponInfoView)
    NSLayoutConstraint.activate([
      couponInfoView.topAnchor
        .constraint(equalTo: PDVInfoView.bottomAnchor, constant: 3),
      couponInfoView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: containerPadding),
      couponInfoView.trailingAnchor
        .constraint(equalTo: containerView.trailingAnchor, constant: -containerPadding)
    ])
  }
  
  private func configureTaxCouponLabel() {
    containerView.addSubview(taxCouponLabel)
    taxCouponLabel.font = .boldSystemFont(ofSize: 16)
    taxCouponLabel.textColor = labelsColor
    taxCouponLabel.textAlignment = .center
    taxCouponLabel.text = "Cupom Fiscal"
    
    taxCouponLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      taxCouponLabel.topAnchor
        .constraint(equalTo: couponInfoView.bottomAnchor, constant: 12),
      taxCouponLabel.leadingAnchor
        .constraint(equalTo: containerView.leadingAnchor, constant: containerPadding),
      taxCouponLabel.trailingAnchor
        .constraint(equalTo: containerView.trailingAnchor, constant: -containerPadding)
    ])
  }
  
  private func configureTaxCouponLabelSeparatorView() {
    containerView.addSubview(taxCouponLabelSeparatorView)
    taxCouponLabelSeparatorView.backgroundColor = separatorViewColor
    
    taxCouponLabelSeparatorView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      taxCouponLabelSeparatorView.topAnchor
        .constraint(equalTo: taxCouponLabel.bottomAnchor, constant: 14),
      taxCouponLabelSeparatorView.leadingAnchor
        .constraint(equalTo: containerView.leadingAnchor),
      taxCouponLabelSeparatorView.trailingAnchor
        .constraint(equalTo: containerView.trailingAnchor),
      taxCouponLabelSeparatorView.heightAnchor.constraint(equalToConstant: 1)
    ])
  }
}

// MARK: ContainerView Bottom
extension YDTaxCouponViewController {
  private func configureBottomViews() {
    configureCollectionView()
    configureCollectionViewSeparatorView()
    
    configureTotalPriceContainerView()
    configureTotalLabel()
    configureTotalValueLabel()
  }
  
  private func configureCollectionView() {
    containerView.addSubview(collectionView)
    collectionView.alwaysBounceVertical = true
    collectionView.backgroundColor = .clear
    
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor
        .constraint(equalTo: taxCouponLabelSeparatorView.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
    ])
    collectionViewHeightConstraint.isActive = true
    
    configureCollectionViewDataSource()
  }
  
  private func configureCollectionViewSeparatorView() {
    containerView.addSubview(collectionViewSeparatorView)
    collectionViewSeparatorView.backgroundColor = separatorViewColor
    
    collectionViewSeparatorView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionViewSeparatorView.topAnchor
        .constraint(equalTo: collectionView.bottomAnchor),
      collectionViewSeparatorView.leadingAnchor
        .constraint(equalTo: containerView.leadingAnchor),
      collectionViewSeparatorView.trailingAnchor
        .constraint(equalTo: containerView.trailingAnchor),
      collectionViewSeparatorView.heightAnchor.constraint(equalToConstant: 1)
    ])
  }
  
  private func configureTotalPriceContainerView() {
    containerView.addSubview(totalPriceContainerView)
    
    totalPriceContainerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      totalPriceContainerView.topAnchor
        .constraint(equalTo: collectionViewSeparatorView.bottomAnchor),
      totalPriceContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      totalPriceContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      totalPriceContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ])
    totalPriceContainerView.setContentHuggingPriority(.defaultLow, for: .vertical)
  }
  
  private func configureTotalLabel() {
    totalPriceContainerView.addSubview(totalLabel)
    totalLabel.font = .boldSystemFont(ofSize: 16)
    totalLabel.textColor = labelsColor
    totalLabel.textAlignment = .left
    totalLabel.text = "Total -"
    
    totalLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      totalLabel.centerYAnchor.constraint(equalTo: totalPriceContainerView.centerYAnchor),
      totalLabel.leadingAnchor.constraint(
        equalTo: totalPriceContainerView.leadingAnchor,
        constant: containerPadding
      )
    ])
  }
  
  private func configureTotalValueLabel() {
    totalPriceContainerView.addSubview(totalValueLabel)
    totalValueLabel.font = .boldSystemFont(ofSize: 16)
    totalValueLabel.textColor = labelsColor
    totalValueLabel.textAlignment = .right
    
    totalValueLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      totalValueLabel.centerYAnchor.constraint(equalTo: totalPriceContainerView.centerYAnchor),
      totalValueLabel.trailingAnchor.constraint(
        equalTo: totalPriceContainerView.trailingAnchor,
        constant: -containerPadding
      )
    ])
  }
}

// MARK: Share Button
extension YDTaxCouponViewController {
  private func configureShare() {
    configureShareContainerView()
    configureShareButton()
  }
  
  private func configureShareContainerView() {
    view.addSubview(shareButtonContainerView)
    
    shareButtonContainerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shareButtonContainerView.topAnchor.constraint(
        greaterThanOrEqualTo: containerView.bottomAnchor,
        constant: 12
      ),
      shareButtonContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      shareButtonContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      shareButtonContainerView.heightAnchor.constraint(equalToConstant: 58),
      shareButtonContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  private func configureShareButton() {
    shareButtonContainerView.addSubview(shareButton)
    shareButton.backgroundColor = .white
    shareButton.layer.cornerRadius = 8
    shareButton.setTitle("compartilhar", for: .normal)
    shareButton.setTitleColor(YDColors.branding, for: .normal)
    shareButton.setTitleColor(YDColors.brandingHighlighted, for: .highlighted)
    shareButton.titleLabel?.font = .systemFont(ofSize: 14)
    
    shareButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shareButton.centerYAnchor.constraint(equalTo: shareButtonContainerView.centerYAnchor),
      shareButton.heightAnchor.constraint(equalToConstant: 40),
      shareButton.leadingAnchor.constraint(equalTo: shareButtonContainerView.leadingAnchor),
      shareButton.trailingAnchor.constraint(equalTo: shareButtonContainerView.trailingAnchor)
    ])
    
    shareButton.addTarget(self, action: #selector(onShareAction), for: .touchUpInside)
  }
}
