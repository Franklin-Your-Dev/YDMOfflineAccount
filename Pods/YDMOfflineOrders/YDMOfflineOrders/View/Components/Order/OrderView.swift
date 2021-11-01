//
//  OrderView.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 09/09/21.
//

import UIKit
import YDExtensions
import YDUtilities
import YDB2WModels
import YDB2WColors

class OrderView: UIView {
  // MARK: Properties
  var stateView: YDUIStateEnum = .normal {
    didSet {
      changeUIState(with: stateView)
    }
  }
  var currentOrder: YDOfflineOrdersOrder?
  var productCallback: ((YDOfflineOrdersProduct) -> Void)?
  var orderDetailsCallback: (() -> Void)?
  var noteCallback: (() -> Void)?
  
  var components: [UIView] = []
  
  lazy var shimmersViews: [UIView] = {
    [
      shimmerDateLabel,
      shimmerProductsCount,
      shimmerPriceLabel,
      shimmerDetailsButton
    ]
  }()
  
  // MARK: Components
  let storeAndAddressView = StoreNameAndAddressView()
  let dateLabel = UILabel()
  let productsCount = UILabel()
  let separatorView = UIView()
  let productsDetailsButton = UIButton()
  let detailsButton = UIButton()
  let valueTotalLabel = UILabel()
  let priceLabel = UILabel()

  let shimmerDateLabel = UIView()
  let shimmerProductsCount = UIView()
  let shimmerPriceLabel = UIView()
  let shimmerDetailsButton = UIView()
  
  // MARK: Init
  init() {
    super.init(frame: .zero)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.shadowPath = UIBezierPath(
      roundedRect: bounds,
      cornerRadius: 16
    ).cgPath
  }
}

// MARK: Actions
extension OrderView {
  func reset() {
    storeAndAddressView.reset()
    dateLabel.text = nil
    productsCount.text = nil
    priceLabel.text = nil
    productCallback = nil
    currentOrder = nil
    orderDetailsCallback = nil
    noteCallback = nil
    changeUIState(with: .normal)
  }
  
  func config(with order: YDOfflineOrdersOrder) {
    currentOrder = order
    
    storeAndAddressView.configure(with: order)
    
    dateLabel.text = order.formattedDate
    priceLabel.text = order.formattedPrice
    
    if let products = order.products {
      productsCount.text = "total de produtos: \(products.count)"
    }
  }
  
  func config(shimmer: Bool = true) {
    changeUIState(with: .loading)
  }
  
  @objc func onOrderDetailsAction() {
    orderDetailsCallback?()
  }
}

// MARK: UI
extension OrderView {
  func configureUI() {
    configureView()
    
    configureStoreNameAndAddress()
    configureDateLabel()
    configureProductsCount()
    configureSeparatorView()
    configureDetailsButton()
    configureValueLabel()

    // Shimmer
    configureShimmerDateLabel()
    configureShimmerProductsCount()
    configureShimmerPriceLabel()
    configureShimmerDetailsButton()
  }
  
  func configureView() {
    backgroundColor = YDColors.white
    layer.applyShadow(alpha: 0.15, x: 0, y: 0, blur: 20)
    layer.cornerRadius = 16

    translatesAutoresizingMaskIntoConstraints = false
  }

  func configureStoreNameAndAddress() {
    addSubview(storeAndAddressView)
    
    NSLayoutConstraint.activate([
      storeAndAddressView.topAnchor.constraint(
        equalTo: topAnchor,
        constant: 16
      ),
      storeAndAddressView.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: 16
      ),
      storeAndAddressView.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -16
      )
    ])
  }

  func configureDateLabel() {
    addSubview(dateLabel)
    components.append(dateLabel)
    
    dateLabel.font = .systemFont(ofSize: 13)
    dateLabel.textAlignment = .left
    dateLabel.textColor = YDColors.Gray.light

    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateLabel.topAnchor.constraint(
        equalTo: storeAndAddressView.bottomAnchor,
        constant: 21
      ),
      dateLabel.leadingAnchor.constraint(equalTo: storeAndAddressView.leadingAnchor),
      dateLabel.heightAnchor.constraint(equalToConstant: 16),
      dateLabel.widthAnchor.constraint(equalToConstant: 80)
    ])
    dateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    dateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
  }

  func configureProductsCount() {
    addSubview(productsCount)
    components.append(productsCount)
    
    productsCount.font = .systemFont(ofSize: 13)
    productsCount.textAlignment = .right
    productsCount.textColor = YDColors.black

    productsCount.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productsCount.topAnchor.constraint(equalTo: storeAndAddressView.bottomAnchor, constant: 11),
      productsCount.leadingAnchor.constraint(
        greaterThanOrEqualTo: dateLabel.trailingAnchor,
        constant: 12
      ),
      productsCount.heightAnchor.constraint(equalToConstant: 35),
      productsCount.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
    ])
  }
  
  func configureSeparatorView() {
    addSubview(separatorView)
    separatorView.backgroundColor = YDColors.Gray.disabled
    
    separatorView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      separatorView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 11),
      separatorView.heightAnchor.constraint(equalToConstant: 1),
      separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
      separatorView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }

  func configureDetailsButton() {
    addSubview(detailsButton)
    components.append(detailsButton)
    
    detailsButton.titleLabel?.font = .systemFont(ofSize: 14)
    detailsButton.setTitleColor(YDColors.branding, for: .normal)
    detailsButton.setTitleColor(YDColors.brandingHighlighted, for: .highlighted)
    detailsButton.setTitle("detalhes da compra", for: .normal)

    detailsButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      detailsButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
      detailsButton.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: -16),
      detailsButton.heightAnchor.constraint(equalToConstant: 35),
      detailsButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
    ])
    detailsButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    detailsButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)

    detailsButton.addTarget(
      self,
      action: #selector(onOrderDetailsAction),
      for: .touchUpInside
    )
  }

  func configureValueLabel() {
    addSubview(valueTotalLabel)
    components.append(valueTotalLabel)
    
    valueTotalLabel.font = .systemFont(ofSize: 12)
    valueTotalLabel.textAlignment = .left
    valueTotalLabel.textColor = YDColors.Gray.light
    valueTotalLabel.numberOfLines = 1
    valueTotalLabel.text = "total:"

    valueTotalLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      valueTotalLabel.topAnchor.constraint(
        equalTo: separatorView.bottomAnchor,
        constant: 17
      ),
      valueTotalLabel.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor, constant: 16),
      valueTotalLabel.heightAnchor.constraint(equalToConstant: 24)
    ])
    valueTotalLabel.setContentCompressionResistancePriority(
      .defaultHigh,
      for: .horizontal
    )
    valueTotalLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

    //
    addSubview(priceLabel)
    components.append(priceLabel)
    
    priceLabel.font = .boldSystemFont(ofSize: 14)
    priceLabel.textAlignment = .left
    priceLabel.textColor = YDColors.black

    priceLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      priceLabel.centerYAnchor.constraint(equalTo: valueTotalLabel.centerYAnchor),
      priceLabel.leadingAnchor.constraint(
        equalTo: valueTotalLabel.trailingAnchor,
        constant: 3
      ),
      priceLabel.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -16
      )
    ])
    priceLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
  }
}

// MARK: Shimmer
extension OrderView {
  func configureShimmerDateLabel() {
    addSubview(shimmerDateLabel)
    shimmerDateLabel.backgroundColor = YDColors.Gray.light
    shimmerDateLabel.layer.cornerRadius = 8
    shimmerDateLabel.clipsToBounds = true
    shimmerDateLabel.isHidden = true

    shimmerDateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerDateLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor),
      shimmerDateLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
      shimmerDateLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
      shimmerDateLabel.heightAnchor.constraint(equalToConstant: 13)
    ])
  }

  func configureShimmerProductsCount() {
    addSubview(shimmerProductsCount)
    shimmerProductsCount.backgroundColor = YDColors.white
    shimmerProductsCount.layer.cornerRadius = 8
    shimmerProductsCount.clipsToBounds = true
    shimmerProductsCount.isHidden = true

    shimmerProductsCount.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerProductsCount.topAnchor.constraint(equalTo: dateLabel.topAnchor),
      shimmerProductsCount.trailingAnchor.constraint(equalTo: productsCount.trailingAnchor),
      shimmerProductsCount.heightAnchor.constraint(equalToConstant: 13),
      shimmerProductsCount.widthAnchor.constraint(equalToConstant: 120)
    ])
  }
   
  func configureShimmerPriceLabel() {
    addSubview(shimmerPriceLabel)
    shimmerPriceLabel.backgroundColor = YDColors.white
    shimmerPriceLabel.layer.cornerRadius = 8
    shimmerPriceLabel.clipsToBounds = true
    shimmerPriceLabel.isHidden = true

    shimmerPriceLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerPriceLabel.topAnchor.constraint(equalTo: valueTotalLabel.topAnchor),
      shimmerPriceLabel.leadingAnchor.constraint(equalTo: valueTotalLabel.leadingAnchor),
      shimmerPriceLabel.heightAnchor.constraint(equalToConstant: 16),
      shimmerPriceLabel.widthAnchor.constraint(equalToConstant: 120)
    ])
  }
  
  func configureShimmerDetailsButton() {
    addSubview(shimmerDetailsButton)
    shimmerDetailsButton.backgroundColor = YDColors.white
    shimmerDetailsButton.layer.cornerRadius = 8
    shimmerDetailsButton.clipsToBounds = true
    shimmerDetailsButton.isHidden = true

    shimmerDetailsButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerDetailsButton.topAnchor.constraint(equalTo: valueTotalLabel.topAnchor),
      shimmerDetailsButton.trailingAnchor.constraint(equalTo: detailsButton.trailingAnchor),
      shimmerDetailsButton.heightAnchor.constraint(equalToConstant: 16),
      shimmerDetailsButton.widthAnchor.constraint(equalToConstant: 98)
    ])
  }
}

// MARK: UIState Delegate
extension OrderView: YDUIStateDelegate {
  func changeUIState(with type: YDUIStateEnum) {
    switch type {
      case .normal:
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          
          self.components.forEach { $0.isHidden = false }
          
          self.shimmersViews.forEach {
            $0.stopShimmer()
            $0.isHidden = true
          }
          self.storeAndAddressView.stopShimmers()
        }

      case .loading:
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          
          self.components.forEach { $0.isHidden = true }

          self.shimmersViews.forEach {
            $0.isHidden = false
            $0.startShimmer()
          }
          self.storeAndAddressView.startShimmers()
        }

      default:
        break
    }
  }
}
