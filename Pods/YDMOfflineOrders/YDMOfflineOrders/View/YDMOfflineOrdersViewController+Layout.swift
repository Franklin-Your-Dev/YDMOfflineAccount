//
//  YDMOfflineOrdersViewController+Layout.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 22/02/21.
//
import UIKit

import YDExtensions
import YDB2WAssets
import YDUtilities
import YDB2WColors

extension YDMOfflineOrdersViewController {
  func setUpLayout() {
    title = "minhas compras nas lojas"
    view.backgroundColor = YDColors.white
    
    configureNavBar()
    createCollectionView()
    createShadowView()
    createFeedbackStateView()
  }
  
  func configureNavBar() {
    guard navigationController?
            .restorationIdentifier == YDConstants.Miscellaneous.OfflineAccount
    else {
      return
    }
    
    let navBar = navigationController?.navigationBar
    if #available(iOS 13.0, *) {
      let appearance = UINavigationBarAppearance()

      appearance.shadowImage = UIImage()
      appearance.backgroundImage = UIImage()
      appearance.titleTextAttributes = [.foregroundColor: YDColors.black]
      appearance.backgroundColor = .white
      appearance.shadowColor = nil

      navBar?.compactAppearance = appearance
      navBar?.standardAppearance = appearance
      navBar?.scrollEdgeAppearance = appearance
    } else {
      navBar?.shadowImage = UIImage()
      navBar?.titleTextAttributes = [.foregroundColor: YDColors.black]
    }

    navBar?.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    navBar?.tintColor = YDColors.black
    navBar?.barTintColor = .white
    
    createBackButton()
  }
  
  func createBackButton() {
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

  @objc func onBackAction(_ sender: UIButton) {
    viewModel?.onBack()
  }

  func createCollectionView() {
    let layoutFlow = UICollectionViewFlowLayout()
    layoutFlow.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 20, right: 0)
    layoutFlow.scrollDirection = .vertical
    layoutFlow.estimatedItemSize = CGSize(width: view.frame.size.width, height: 235)
    layoutFlow.minimumLineSpacing = 16

    collectionView = UICollectionView(
      frame: view.frame,
      collectionViewLayout: layoutFlow
    )

    view.addSubview(collectionView)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .clear
    collectionView.alwaysBounceVertical = true

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    
    // List height / cell  height
    numberOfShimmers = Int(
      (collectionView.frame.size.height / cellSize).rounded(.up)
    ) + 1

    // Order cell
    collectionView.register(
      OrdersCollectionViewCell.self,
      forCellWithReuseIdentifier: OrdersCollectionViewCell.identifier
    )

    // Header cell
    collectionView.register(
      OrdersHeaderCollectionViewCell.self,
      forCellWithReuseIdentifier: OrdersHeaderCollectionViewCell.identifier
    )

    // Header section
    collectionView.register(
      OrdersCollectionFooterReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: OrdersCollectionFooterReusableView.identifier
    )

    // Loading footer
    collectionView.register(
      OrdersLoadingCollectionFooterReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: OrdersLoadingCollectionFooterReusableView.identifier
    )
  }

  func createShadowView() {
    shadowView.backgroundColor = .clear
    view.addSubview(shadowView)

    shadowView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shadowView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -1),
      shadowView.heightAnchor.constraint(equalToConstant: 1),
      shadowView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      shadowView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }

  func createFeedbackStateView() {
    view.addSubview(feedbackStateView)

    feedbackStateView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      feedbackStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      feedbackStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      feedbackStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])

    createFeedbackStateIcon()
    createFeedbackStateLabel()
    createFeedbackStateButton()
  }

  func createFeedbackStateIcon() {
    feedbackStateIcon.image = YDAssets.Images.basket
    feedbackStateView.addSubview(feedbackStateIcon)

    feedbackStateIcon.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      feedbackStateIcon.topAnchor.constraint(
        equalTo: feedbackStateView.topAnchor,
        constant: 32
      ),
      feedbackStateIcon.centerXAnchor.constraint(equalTo: feedbackStateView.centerXAnchor),
      feedbackStateIcon.widthAnchor.constraint(equalToConstant: 72),
      feedbackStateIcon.heightAnchor.constraint(equalToConstant: 72)
    ])
  }

  func createFeedbackStateLabel() {
    feedbackMessage.font = .systemFont(ofSize: 16)
    feedbackMessage.textColor = YDColors.Gray.light
    feedbackMessage.textAlignment = .center
    feedbackMessage.numberOfLines = 0
    feedbackMessage.text = """
    Ops! Você ainda não possui um histórico de compras realizadas em nossas lojas físicas.
    Pro seu histórico aparecer aqui, lembre sempre de informar seu CPF na hora do pagamento em uma de nossas lojas :)
    """
    feedbackStateView.addSubview(feedbackMessage)

    feedbackMessage.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      feedbackMessage.topAnchor.constraint(equalTo: feedbackStateIcon.bottomAnchor, constant: 12),
      feedbackMessage.leadingAnchor
        .constraint(equalTo: feedbackStateView.leadingAnchor, constant: 20),
      feedbackMessage.trailingAnchor
        .constraint(equalTo: feedbackStateView.trailingAnchor, constant: -20)
    ])
  }

  func createFeedbackStateButton() {
    feedbackStateButton.layer.cornerRadius = 4
    feedbackStateButton.layer.borderWidth = 2
    feedbackStateButton.layer.borderColor = YDColors.branding.cgColor

    let attributedString = NSAttributedString(
      string: "ver loja mais próxima",
      attributes: [
        NSAttributedString.Key.foregroundColor: YDColors.branding,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)
      ]
    )
    feedbackStateButton.setAttributedTitle(attributedString, for: .normal)
    feedbackStateView.addSubview(feedbackStateButton)
    feedbackStateButton.addTarget(
      self,
      action: #selector(onFeedbackButtonAction),
      for: .touchUpInside
    )

    feedbackStateButton.translatesAutoresizingMaskIntoConstraints = false

    feedbackStateButtonWidthConstraint = feedbackStateButton.widthAnchor
      .constraint(equalToConstant: 155)
    feedbackStateButtonWidthConstraint?.isActive = true

    NSLayoutConstraint.activate([
      feedbackStateButton.topAnchor.constraint(equalTo: feedbackMessage.bottomAnchor, constant: 24),
      feedbackStateButton.centerXAnchor.constraint(equalTo: feedbackStateView.centerXAnchor),
      feedbackStateButton.heightAnchor.constraint(equalToConstant: 40),
      feedbackStateButton.bottomAnchor.constraint(
        equalTo: feedbackStateView.bottomAnchor,
        constant: -20
      )
    ])
  }
}
