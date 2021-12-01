//
//  YDTaxCouponContainerViewController+Layouts.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 26/08/21.
//

import UIKit

extension YDTaxCouponContainerViewController {
  func configureUI() {
    view.backgroundColor = .black.withAlphaComponent(0.5)
    
    configureContainerView()
  }
  
  private func configureContainerView() {
    view.addSubview(containerView)
    
    containerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
}
