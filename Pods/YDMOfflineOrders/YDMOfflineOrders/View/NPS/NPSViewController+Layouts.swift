//
//  NPSViewController+Layouts.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 19/10/21.
//

import UIKit
import YDB2WComponents
import YDB2WAssets

extension NPSViewController {
  func configureUI() {
    view.backgroundColor = .white
    
    configureNavBar()
    configureShadow()
    configureNPSView()
  }
}

// MARK: NavBar
extension NPSViewController {
  private func configureNavBar() {
    title = "conta pra gente:"
    
    configureNavBarBackButton()
  }
  
  private func configureNavBarBackButton() {
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
}

// MARK: Shadow
extension NPSViewController {
  private func configureShadow() {
    view.addSubview(shadowView)
    shadowView.backgroundColor = .white

    shadowView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shadowView.topAnchor.constraint(equalTo: view.topAnchor, constant: -6),
      shadowView.heightAnchor.constraint(equalToConstant: 5),
      shadowView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      shadowView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
}

// MARK: NPS Expanded Component
extension NPSViewController {
  private func configureNPSView() {
    let npsView = YDNPSExpandedViewController(spaceyViewModel: viewModel?.spaceyViewModel)
    self.npsView = npsView
    
    npsView.willMove(toParent: self)
    addChild(npsView)
    
    self.npsView?.UIDelegate = self
    self.npsView?.actionDelegate = self
    
    npsView.didMove(toParent: self)
    
    view.addSubview(npsView.view)
    
    npsView.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      npsView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      npsView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      npsView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    npsViewBottomConstraint?.isActive = true
  }
}
