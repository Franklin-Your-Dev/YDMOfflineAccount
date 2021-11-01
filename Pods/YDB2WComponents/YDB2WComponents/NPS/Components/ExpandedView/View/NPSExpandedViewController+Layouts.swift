//
//  NPSExpandedViewController+Layouts.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 18/10/21.
//

import UIKit

extension YDNPSExpandedViewController {
  func configureUI() {
    view.backgroundColor = .white
    
    configureSendButton()
    configureSpaceyUI()
    configureBottomShadowView()
    configureShimmerView()
  }
}

// MARK: Send Button
extension YDNPSExpandedViewController {
  private func configureSendButton() {
    view.addSubview(sendButton)
    sendButton.setEnabled(false)
    
    let padding: CGFloat = 16
    
    NSLayoutConstraint.activate([
      sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
      sendButton.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor,
        constant: -padding
      )
    ])
    
    sendButton.callback = onSendButtonAction
  }
}

// MARK: SpaceyUI
extension YDNPSExpandedViewController {
  private func configureSpaceyUI() {
    let viewModel = self.spaceyViewModel ??
      YDSpaceyViewModel(
        supportedTypes: nil,
        supportedNPSAnswersTypes: nil
      )
    
    let vc = YDSpaceyViewController()
    vc.viewModel = viewModel
    vc.hasShimmer = false
    vc.view.isHidden = true
    
    vc.willMove(toParent: self)
    view.addSubview(vc.view)
    addChild(vc)
    vc.didMove(toParent: self)
    
    spaceyViewController = vc
    spaceyViewController?.delegate = self

    vc.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      vc.view.topAnchor.constraint(equalTo: view.topAnchor),
      vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      vc.view.bottomAnchor.constraint(
        equalTo: sendButton.topAnchor,
        constant: -6
      )
    ])
  }
}

// MARK: Shadow
extension YDNPSExpandedViewController {
  private func configureBottomShadowView() {
    view.addSubview(bottomShadowView)
    bottomShadowView.backgroundColor = .white

    bottomShadowView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      bottomShadowView.bottomAnchor.constraint(equalTo: sendButton.topAnchor, constant: -6),
      bottomShadowView.heightAnchor.constraint(equalToConstant: 1),
      bottomShadowView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      bottomShadowView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
}

// MARK: Shimmer View
extension YDNPSExpandedViewController {
  private func configureShimmerView() {
    view.addSubview(shimmerView)
    view.bringSubviewToFront(shimmerView)

    NSLayoutConstraint.activate([
      shimmerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
      shimmerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      shimmerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      shimmerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}
