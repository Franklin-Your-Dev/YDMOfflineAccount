//
//  SpaceyProductLoadingFooterView.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 01/10/21.
//

import UIKit
import YDExtensions

class SpaceyProductLoadingFooterView: UICollectionReusableView {
  // MARK: Properties
  var shimmers: [UIView] = []
  
  // MARK: Components
  let containerView = UIView()
  let photoView = UIView()
  let titleView = UIView()
  let rateView = UIView()
  let buttonView = UIView()
  let priceConditionView = UIView()
  let priceView = UIView()
  
  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    startAnimate()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    containerView.layer.applyShadow()
    containerView.layer.shadowPath = UIBezierPath(
      roundedRect: containerView.bounds,
      cornerRadius: 6
    ).cgPath
  }
  
  // MARK: Actions
  func startAnimate() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.isHidden = false
      
      self.shimmers.forEach { $0.startShimmer() }
    }
  }
  
  func stopAnimate() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.isHidden = true
      
      self.shimmers.forEach { $0.stopShimmer() }
    }
  }
}

// MARK: UI
extension SpaceyProductLoadingFooterView {
  private func configureUI() {
    configureContainerView()
    configurePhotoView()
    configureTitleView()
    configureRateView()
    configureButtonView()
    configurePriceConditionView()
    configurePriceView()
  }
  
  private func configureContainerView() {
    addSubview(containerView)
    containerView.backgroundColor = .white
    containerView.layer.cornerRadius = 6
    
    containerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: topAnchor),
      containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  private func configurePhotoView() {
    containerView.addSubview(photoView)
    shimmers.append(photoView)
    
    photoView.backgroundColor = .white
    photoView.layer.cornerRadius = 6
    
    photoView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      photoView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
      photoView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
      photoView.widthAnchor.constraint(equalToConstant: 116),
      photoView.heightAnchor.constraint(equalToConstant: 116)
    ])
  }
  
  private func configureTitleView() {
    containerView.addSubview(titleView)
    shimmers.append(titleView)
    
    titleView.backgroundColor = .white
    titleView.layer.cornerRadius = 4
    
    titleView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
      titleView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
      titleView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
      titleView.heightAnchor.constraint(equalToConstant: 34)
    ])
  }
  
  private func configureRateView() {
    containerView.addSubview(rateView)
    shimmers.append(rateView)
    
    rateView.backgroundColor = .white
    rateView.layer.cornerRadius = 4
    
    rateView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      rateView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 4),
      rateView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
      rateView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
      rateView.heightAnchor.constraint(equalToConstant: 12)
    ])
  }
  
  private func configureButtonView() {
    containerView.addSubview(buttonView)
    shimmers.append(buttonView)
    
    buttonView.backgroundColor = .white
    buttonView.layer.cornerRadius = 4
    
    buttonView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      buttonView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -14),
      buttonView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
      buttonView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
      buttonView.heightAnchor.constraint(equalToConstant: 40)
    ])
  }
  
  private func configurePriceConditionView() {
    containerView.addSubview(priceConditionView)
    shimmers.append(priceConditionView)
    
    priceConditionView.backgroundColor = .white
    priceConditionView.layer.cornerRadius = 4
    
    priceConditionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      priceConditionView.bottomAnchor.constraint(
        equalTo: buttonView.topAnchor,
        constant: -18
      ),
      priceConditionView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
      priceConditionView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
      priceConditionView.heightAnchor.constraint(equalToConstant: 12)
    ])
  }
  
  private func configurePriceView() {
    containerView.addSubview(priceView)
    shimmers.append(priceView)
    
    priceView.backgroundColor = .white
    priceView.layer.cornerRadius = 4
    
    priceView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      priceView.bottomAnchor.constraint(
        equalTo: priceConditionView.topAnchor,
        constant: -8
      ),
      priceView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
      priceView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
      priceView.heightAnchor.constraint(equalToConstant: 20)
    ])
  }
}
