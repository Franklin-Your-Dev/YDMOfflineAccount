//
//  OrderDetailsViewController+Layout.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 12/03/21.
//
import UIKit

import YDExtensions
import YDB2WAssets
import YDB2WModels
import YDUtilities
import YDB2WColors

extension OrderDetailsViewController {
  func setUpLayout() {
    title = "detalhes da compra"
    view.backgroundColor = YDColors.white
    setUpNavBar()
    
    configureStoreNameAndAddressView()
    configureStoreAndAddressSeparatorView()
    
    configureNPSView()
    
    configureDateAndDescriptionContainer()
    configureDateLabel()
    configureDescriptionButton()
    
    configureTaxCouponAndInvoiceContainer()
    configureTaxCouponButton()
    configureNoteButton()
    configureSeparatorBottomTaxCouponContainerView()
    
    configureCollectionView()
    createShadow(fromTop: true)
    createShadow(fromTop: false)

    configureTotalPriceContainer()
    configureTotalProductsLabel()
    configurePriceLabel()
  }

  func setUpNavBar() {
    guard navigationController?
            .restorationIdentifier == YDConstants.Miscellaneous.OfflineAccount
    else {
      return
    }
    
    let backButtonView = UIButton()
    backButtonView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
    backButtonView.layer.cornerRadius = 16
    backButtonView.layer.applyShadow()
    backButtonView.backgroundColor = .white
    backButtonView.setImage(YDAssets.Icons.leftArrow, for: .normal)
    backButtonView.addTarget(self, action: #selector(onBackAction), for: .touchUpInside)

    let backButton = UIBarButtonItem()
    backButton.customView = backButtonView

    navigationItem.leftBarButtonItem = backButton
  }

  func createShadow(fromTop: Bool) {
    let shadow = UIView()
    shadow.backgroundColor = .white

    if fromTop {
      view.insertSubview(shadow, belowSubview: taxCouponAndInvoiceContainer)
    } else {
      view.addSubview(shadow)
    }

    shadow.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shadow.heightAnchor.constraint(equalToConstant: 5),
      shadow.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      shadow.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])

    if fromTop {
      shadow.topAnchor
        .constraint(equalTo: separatorBottomTaxCouponContainerView.topAnchor, constant: -6)
        .isActive = true
      shadowTop = shadow
    } else {
      shadow.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
      shadow.layer.applyShadow(y: -2)
      shadowBottom = shadow
    }
  }
  
  func applyCommonConfigurationToSeparator(_ separator: inout UIView, onParent parent: UIView) {
    separator.backgroundColor = YDColors.Gray.disabled
    
    separator.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      separator.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: padding),
      separator.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -padding),
      separator.heightAnchor.constraint(equalToConstant: 1)
    ])
  }
}

// MARK: Store and Address view
extension OrderDetailsViewController {
  private func configureStoreNameAndAddressView() {
    view.addSubview(storeNameAndAddress)
    NSLayoutConstraint.activate([
      storeNameAndAddress.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor,
        constant: 28
      ),
      storeNameAndAddress.leadingAnchor.constraint(
        equalTo: view.leadingAnchor,
        constant: padding
      ),
      storeNameAndAddress.trailingAnchor.constraint(
        equalTo: view.trailingAnchor,
        constant: -padding
      )
    ])
  }
  
  private func configureStoreAndAddressSeparatorView() {
    view.addSubview(storeAndAddressSeparatorView)
    applyCommonConfigurationToSeparator(&storeAndAddressSeparatorView, onParent: view)
    
    NSLayoutConstraint.activate([
      storeAndAddressSeparatorView.topAnchor.constraint(
        equalTo: storeNameAndAddress.bottomAnchor,
        constant: 20
      )
    ])
  }
}

// MARK: NPS View
extension OrderDetailsViewController {
  private func configureNPSView() {
    view.addSubview(NPSView)
    NPSView.isHidden = true
    
    NSLayoutConstraint.activate([
      NPSView.topAnchor.constraint(equalTo: storeAndAddressSeparatorView.bottomAnchor),
      NPSView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      NPSView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    NPSView.heightConstraint.constant = 0
    
    NPSView.callback = onNPSViewTapAction
    
    // Separator
    NPSView.addSubview(NPSViewSeparatorView)
    applyCommonConfigurationToSeparator(&NPSViewSeparatorView, onParent: NPSView)
    NPSViewSeparatorView.isHidden = true
    
    NSLayoutConstraint.activate([
      NPSViewSeparatorView.topAnchor.constraint(equalTo: NPSView.bottomAnchor)
    ])
  }
}

// MARK: Date and Description
extension OrderDetailsViewController {
  private func configureDateAndDescriptionContainer() {
    view.addSubview(dateAndDescriptionContainer)
    dateAndDescriptionContainer.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      dateAndDescriptionContainer.topAnchor.constraint(
        equalTo: NPSViewSeparatorView.bottomAnchor
      ),
      dateAndDescriptionContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      dateAndDescriptionContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      dateAndDescriptionContainer.heightAnchor.constraint(equalToConstant: 50)
    ])
  }
  
  private func configureDateLabel() {
    dateAndDescriptionContainer.addSubview(dateLabel)
    dateLabel.font = .systemFont(ofSize: 13)
    dateLabel.textAlignment = .left
    dateLabel.textColor = YDColors.Gray.light

    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateLabel.leadingAnchor.constraint(
        equalTo: dateAndDescriptionContainer.leadingAnchor,
        constant: padding
      ),
      dateLabel.centerYAnchor.constraint(equalTo: dateAndDescriptionContainer.centerYAnchor)
    ])
  }
  
  private func configureDescriptionButton() {
    dateAndDescriptionContainer.addSubview(descriptionButton)
    descriptionButton.tintColor = YDColors.Gray.lightHighlighted
    
    descriptionButton.setTitle("entenda as diferenças", for: .normal)
    descriptionButton.setTitleColor(YDColors.Gray.light, for: .normal)
    descriptionButton.setTitleColor(YDColors.Gray.lightHighlighted, for: .highlighted)
    descriptionButton.titleLabel?.font = .systemFont(ofSize: 13)
    descriptionButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
    
    descriptionButton.setImage(YDAssets.Icons.info, for: .normal)
    descriptionButton.setImage(YDAssets.Icons.info, for: .highlighted)
    descriptionButton.semanticContentAttribute = .forceRightToLeft
    
    descriptionButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      descriptionButton.heightAnchor.constraint(equalToConstant: 40),
      descriptionButton.centerYAnchor.constraint(
        equalTo: dateAndDescriptionContainer.centerYAnchor
      ),
      descriptionButton.trailingAnchor.constraint(
        equalTo: dateAndDescriptionContainer.trailingAnchor,
        constant: -padding
      )
    ])
    
    descriptionButton.addTarget(
      self,
      action: #selector(onDescriptionAction),
      for: .touchUpInside
    )
  }
}

// MARK: Tax Coupon and Invoice
extension OrderDetailsViewController {
  private func configureTaxCouponAndInvoiceContainer() {
    view.addSubview(taxCouponAndInvoiceContainer)
      
    taxCouponAndInvoiceContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      taxCouponAndInvoiceContainer.topAnchor.constraint(
        equalTo: dateAndDescriptionContainer.bottomAnchor
      ),
      taxCouponAndInvoiceContainer.heightAnchor.constraint(equalToConstant: 40),
      taxCouponAndInvoiceContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      taxCouponAndInvoiceContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
  
  private func configureTaxCouponButton() {
    taxCouponAndInvoiceContainer.addSubview(taxCouponButton)
    taxCouponButton.addTarget(self, action: #selector(onTaxCouponAction), for: .touchUpInside)

    taxCouponButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      taxCouponButton.centerYAnchor.constraint(
        equalTo: taxCouponAndInvoiceContainer.centerYAnchor
      ),
      taxCouponButton.leadingAnchor
        .constraint(equalTo: taxCouponAndInvoiceContainer.leadingAnchor, constant: padding)
    ])
    
    if orderNoteButtonEnabled {
      taxCouponTrailingConstraint.isActive = true
    } else {
      taxCouponFullTrailingConstraint.isActive = true
    }
  }
  
  private func configureNoteButton() {
    taxCouponAndInvoiceContainer.addSubview(noteButton)
    noteButton.addTarget(self, action: #selector(onNoteAction), for: .touchUpInside)

    noteButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      noteButton.centerYAnchor.constraint(equalTo: taxCouponAndInvoiceContainer.centerYAnchor),
      noteButton.trailingAnchor.constraint(
        equalTo: taxCouponAndInvoiceContainer.trailingAnchor, constant: -padding
      )
    ])
    
    if orderNoteButtonEnabled {
      noteButtonLeadingConstraint.isActive = true
    } else {
      noteButton.isHidden = true
    }
  }
  
  private func configureSeparatorBottomTaxCouponContainerView() {
    view.addSubview(separatorBottomTaxCouponContainerView)
    applyCommonConfigurationToSeparator(&separatorBottomTaxCouponContainerView, onParent: view)

    NSLayoutConstraint.activate([
      separatorBottomTaxCouponContainerView.topAnchor.constraint(
        equalTo: taxCouponAndInvoiceContainer.bottomAnchor,
        constant: padding
      )
    ])
  }
}

// MARK: Collectionview
extension OrderDetailsViewController {
  func configureCollectionView() {
    let layoutFlow = UICollectionViewFlowLayout()
    layoutFlow.sectionInset = UIEdgeInsets(
      top: 5,
      left: 0,
      bottom: 25,
      right: 0
    )

    layoutFlow.headerReferenceSize = CGSize(width: view.frame.size.width, height: 30)
    layoutFlow.itemSize = CGSize(width: view.frame.size.width, height: 50)
    layoutFlow.scrollDirection = .vertical
    layoutFlow.minimumLineSpacing = 16

    collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layoutFlow)
    view.addSubview(collectionView)

    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .clear
    collectionView.alwaysBounceVertical = true

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor
        .constraint(equalTo: separatorBottomTaxCouponContainerView.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])

    collectionView.register(
      OrderDetailsCollectionViewCell.self,
      forCellWithReuseIdentifier: OrderDetailsCollectionViewCell.identifier
    )

    collectionView.register(
      OrdersCollectionFooterReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: OrdersCollectionFooterReusableView.identifier
    )

    collectionView.register(
      OrdersLoadingCollectionFooterReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: OrdersLoadingCollectionFooterReusableView.identifier
    )
  }
}

// MARK: Total Price Container
extension OrderDetailsViewController {
  private func configureTotalPriceContainer() {
    view.addSubview(priceContainer)
    priceContainer.backgroundColor = YDColors.white

    let bottom = (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) + 63
    
    priceContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      priceContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      priceContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      priceContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      priceContainer.heightAnchor.constraint(equalToConstant: bottom),
      
      collectionView.bottomAnchor.constraint(equalTo: priceContainer.topAnchor)
    ])
  }
  
  private func configureTotalProductsLabel() {
    priceContainer.addSubview(totalProductsLabel)
    totalProductsLabel.textColor = YDColors.Gray.light
    totalProductsLabel.textAlignment = .left
    totalProductsLabel.font = .systemFont(ofSize: 13)
    
    totalProductsLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      totalProductsLabel.topAnchor.constraint(equalTo: priceContainer.topAnchor, constant: 26),
      totalProductsLabel.leadingAnchor.constraint(
        equalTo: priceContainer.leadingAnchor,
        constant: padding
      )
    ])
  }

  private func configurePriceLabel() {
    priceContainer.addSubview(priceLabel)
    priceLabel.font = .boldSystemFont(ofSize: 24)
    priceLabel.textAlignment = .right
    priceLabel.textColor = YDColors.black
    
    priceLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      priceLabel.topAnchor.constraint(equalTo: priceContainer.topAnchor, constant: 18),
      priceLabel.trailingAnchor.constraint(
        equalTo: priceContainer.trailingAnchor,
        constant: -padding
      )
    ])
  }
}
