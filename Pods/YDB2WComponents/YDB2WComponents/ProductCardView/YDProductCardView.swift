//
//  YDProductCardView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 25/03/21.
//

import UIKit

import Cosmos
import YDExtensions
import YDB2WModels
import YDB2WAssets
import YDUtilities
import YDB2WColors

public class YDProductCardView: UIView {
  // MARK: Properties
  public var stateView: YDUIStateEnum = .normal {
    didSet {
      changeUIState(with: stateView)
    }
  }
  public var product: YDProduct? {
    didSet {
      updateLayoutWithProduct()
    }
  }
  var itsOnline = false
  var shimmers: [UIView] = []

  // MARK: Components
  let container = UIView()
  let photoImageView = UIImageView()
  let photoImageMask = UIView()
  let productNameLabel = UILabel()
  let productPriceLabel = UILabel()
  let shippingLabel = UILabel()
  let buyButton = UIButton()
  let ratingView = CosmosView()

  let shimmerContainer = UIView()
  let shimmerPhoto = UIView()
  let shimmerProductName = UIView()
  let shimmerProductRate = UIView()
  let shimmerProductPrice = UIView()

  // MARK: Init
  public override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = YDColors.white
    layer.applyShadow(x: 0, y: 0, blur: 20)
    heightAnchor.constraint(equalToConstant: 120).isActive = true
    setUpLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public init(fromOnline: Bool) {
    super.init(frame: .zero)
    itsOnline = fromOnline
    backgroundColor = YDColors.white
    layer.applyShadow(x: 0, y: 0, blur: 20)
    heightAnchor.constraint(equalToConstant: 120).isActive = true
    setUpLayout()
  }

  // MARK: Actions
  private func updateLayoutWithProduct() {
    guard let product = self.product else { return }
    
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      
      self.photoImageView.setImage(product.image, placeholder: YDAssets.Icons.imagePlaceHolder)
      self.productNameLabel.text = product.name?.lowercased()
      self.productPriceLabel.text = product.formatedPrice
      self.shippingLabel.isHidden = false

      if self.itsOnline { return }

      if let rate = product.rating?.average,
         rate > 0,
         let rateText = product.rating?.recommendations {
        self.ratingView.isHidden = false
        self.ratingView.rating = rate
        self.ratingView.text = "(\(rateText))"
      } else {
        self.ratingView.isHidden = true
      }
    }
  }
}
