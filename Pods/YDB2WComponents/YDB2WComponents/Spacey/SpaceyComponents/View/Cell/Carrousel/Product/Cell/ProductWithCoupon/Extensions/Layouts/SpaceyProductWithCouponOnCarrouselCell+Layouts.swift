//
//  SpaceyProductOnCarrouselCell+Layouts.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 01/10/21.
//

import UIKit
import YDExtensions
import YDB2WAssets

extension SpaceyProductWithCouponOnCarrouselCell {
  func configureUI() {
    configureProductView()
  }
  
  private func configureProductView() {
    contentView.addSubview(productView)
    
    NSLayoutConstraint.activate([
      productView.topAnchor.constraint(equalTo: contentView.topAnchor),
      productView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      productView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      productView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
}
