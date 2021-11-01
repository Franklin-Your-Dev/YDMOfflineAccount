//
//  SpaceyProductOnCarrouselCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 01/10/21.
//

import UIKit
import Cosmos
import YDExtensions
import YDB2WAssets
import YDB2WModels
import YDUtilities

class SpaceyProductWithCouponOnCarrouselCell: UICollectionViewCell {
  // MARK: Properties
  var product: YDSpaceyProduct? {
    didSet {
      productView.configure(with: product)
    }
  }
  
  var callbackProductTap: (() -> Void)? {
    didSet {
      productView.callbackProductTap = callbackProductTap
    }
  }
  
  var callbackAddToCartTap: (() -> Void)? {
    didSet {
      productView.callbackAddToCartTap = callbackAddToCartTap
    }
  }
  
  var callbackCouponTap: (() -> Void)? {
    didSet {
      productView.callbackCouponTap = callbackCouponTap
    }
  }
  
  // MARK: Components
  let productView = YDProductOnCarrouselView()
  
  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Life cycle
  override func prepareForReuse() {
    callbackProductTap = nil
    callbackAddToCartTap = nil
    callbackCouponTap = nil
    product = nil
    productView.prepareView()
    super.prepareForReuse()
  }

  // MARK: Config
  func config(with product: YDSpaceyProduct) {
    self.product = product
  }
}
