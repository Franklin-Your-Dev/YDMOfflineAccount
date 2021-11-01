//
//  YDTaxCouponViewCell.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 26/08/21.
//

import UIKit
import YDB2WModels
import YDExtensions
import YDB2WColors

class YDTaxCouponViewCell: UICollectionViewCell {
  // MARK: Properties
  let padding: CGFloat = 16
  
  // MARK: Components
  lazy var width: NSLayoutConstraint = {
    let width = contentView.widthAnchor
      .constraint(equalToConstant: bounds.size.width)
    width.isActive = true
    return width
  }()
  
  let productNameLabel = UILabel()
  let productEANLabel = UILabel()
  let productPriceLabel = UILabel()
  let productHowManyLabel = UILabel()
  
  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func systemLayoutSizeFitting(
    _ targetSize: CGSize,
    withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
    verticalFittingPriority: UILayoutPriority
  ) -> CGSize {
    width.constant = bounds.size.width
    return contentView.systemLayoutSizeFitting(
      CGSize(width: targetSize.width, height: 1)
    )
  }
  
  override func prepareForReuse() {
    productNameLabel.text = nil
    productEANLabel.text = nil
    productPriceLabel.text = nil
    productHowManyLabel.text = nil
    super.prepareForReuse()
  }
  
  // MARK: Configure
  func configure(with product: YDOfflineOrdersProduct) {
    productNameLabel.text = product.originalName
    productEANLabel.text = "ean - " + (product.ean ?? "")
    productPriceLabel.text = product.formatedPrice
    
    let howMany = product.howMany
    let finalHowMany = howMany <= 9 ? "0\(howMany)" : "\(howMany)"
    
    productHowManyLabel.text = "\(finalHowMany) PCE x"
  }
}

// MARK: UI
extension YDTaxCouponViewCell {
  private func configureUI() {
    configureProductNameLabel()
    configureProductEANLabel()
    configureProductPriceLabel()
    configureProductHowManyLabel()
  }
  
  private func configureProductNameLabel() {
    contentView.addSubview(productNameLabel)
    productNameLabel.numberOfLines = 2
    productNameLabel.font = .systemFont(ofSize: 13)
    productNameLabel.textColor = YDColors.black
    productNameLabel.textAlignment = .left
    
    productNameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
      productNameLabel.leadingAnchor
        .constraint(equalTo: contentView.leadingAnchor, constant: padding),
      productNameLabel.trailingAnchor
        .constraint(equalTo: contentView.trailingAnchor, constant: -114),
      productNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 16)
    ])
    productNameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
  }
  
  private func configureProductEANLabel() {
    contentView.addSubview(productEANLabel)
    productEANLabel.font = .systemFont(ofSize: 12)
    productEANLabel.textColor = YDColors.black
    productEANLabel.textAlignment = .left
    
    productEANLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productEANLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 2),
      productEANLabel.leadingAnchor
        .constraint(equalTo: contentView.leadingAnchor, constant: padding),
      productEANLabel.trailingAnchor
        .constraint(equalTo: contentView.trailingAnchor, constant: -114),
      productEANLabel.heightAnchor.constraint(equalToConstant: 14),
      productEANLabel.bottomAnchor
        .constraint(equalTo: contentView.bottomAnchor, constant: -4)
    ])
    productEANLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
  }
  
  private func configureProductPriceLabel() {
    contentView.addSubview(productPriceLabel)
    productPriceLabel.font = .systemFont(ofSize: 12)
    productPriceLabel.textColor = YDColors.black
    productPriceLabel.textAlignment = .right
    
    productPriceLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productPriceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
      productPriceLabel.trailingAnchor
        .constraint(equalTo: contentView.trailingAnchor, constant: -padding)
    ])
  }
  
  private func configureProductHowManyLabel() {
    contentView.addSubview(productHowManyLabel)
    productHowManyLabel.font = .systemFont(ofSize: 12)
    productHowManyLabel.textColor = YDColors.black
    productHowManyLabel.textAlignment = .right
    
    productHowManyLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productHowManyLabel.topAnchor.constraint(equalTo: productPriceLabel.bottomAnchor, constant: 4),
      productHowManyLabel.trailingAnchor
        .constraint(equalTo: contentView.trailingAnchor, constant: -padding)
    ])
  }
}
