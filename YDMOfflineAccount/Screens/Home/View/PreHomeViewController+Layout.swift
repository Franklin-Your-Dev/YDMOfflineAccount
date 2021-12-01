//
//  HomeViewController+Layout.swift
//  YDMstoreModeOfflineAccount
//
//  Created by Douglas Hennrich on 17/02/21.
//

import UIKit

import YDB2WAssets
import YDExtensions
import YDB2WColors

extension PreHomeViewController {
  func setUpLayout() {
    setViewBackgroundImage()
    createOpacityMask()
    createContainerView()
    createNavBar()
  }

  func setViewBackgroundImage() {
    if let image = YDAssets.Images.map {
      view.backgroundColor = UIColor(patternImage: image)
      view.hero.id = "background"
    }
  }

  func createOpacityMask() {
    let opacityView = UIView()
    opacityView.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    view.addSubview(opacityView)

    opacityView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      opacityView.topAnchor.constraint(equalTo: view.topAnchor),
      opacityView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      opacityView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      opacityView.heightAnchor.constraint(equalToConstant: 100)
    ])
  }

  func createContainerView() {
    let containerView = UIView()
    containerView.backgroundColor = .white
    containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    containerView.layer.cornerRadius = 16

    view.addSubview(containerView)

    containerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                         constant: 18),
      containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }

  func createNavBar() {
    guard let container = view.subviews.at(1) else { return }

    let vc = UIViewController()
    navBar = UINavigationController(rootViewController: vc)
    if #available(iOS 13.0, *) {
      let appearance = UINavigationBarAppearance()

      appearance.shadowImage = UIImage()
      appearance.backgroundImage = UIImage()
      appearance.titleTextAttributes = [.foregroundColor: YDColors.black]
      appearance.backgroundColor = .white
      appearance.shadowColor = nil

      navBar.navigationBar.compactAppearance = appearance
      navBar.navigationBar.standardAppearance = appearance
      navBar.navigationBar.scrollEdgeAppearance = appearance
    } else {
      navBar.navigationBar.shadowImage = UIImage()
      navBar.navigationBar.titleTextAttributes = [
        .foregroundColor: YDColors.black
      ]
    }

    navBar.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    navBar.navigationBar.tintColor = YDColors.black

    addChild(navBar)
    container.addSubview(navBar.view)

    navBar.navigationBar.isTranslucent = false
    navBar.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    navBar.view.layer.cornerRadius = 16
    navBar.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      navBar.view.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
      navBar.view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
      navBar.view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
      navBar.view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
    ])

    navBar.didMove(toParent: self)
  }
}
