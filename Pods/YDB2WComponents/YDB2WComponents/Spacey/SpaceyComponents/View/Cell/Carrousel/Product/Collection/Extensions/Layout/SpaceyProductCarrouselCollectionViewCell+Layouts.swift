//
//  SpaceyProductCarrouselCollectionViewCell+Layouts.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 01/10/21.
//

import UIKit
import YDExtensions
import YDB2WColors

extension SpaceyProductCarrouselCollectionViewCell {
  func configureUI() {
    contentView.translatesAutoresizingMaskIntoConstraints = false
    
    configureHeaderLabel()
    configureLivePulseView()
    configureCollectionView()
  }
}

// MARK: Header
extension SpaceyProductCarrouselCollectionViewCell {
  private func configureHeaderLabel() {
    contentView.addSubview(headerLabel)
    headerLabel.font = .boldSystemFont(ofSize: 24)
    headerLabel.textAlignment = .left
    headerLabel.numberOfLines = 2
    headerLabel.textColor = YDColors.black
    
    headerLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
      headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      
      headerLabelHeightConstraint,
      headerLabelTrailingConstraint
    ])
  }
  
  private func configureLivePulseView() {
    contentView.addSubview(livePulseView)

    livePulseView.backgroundColor = YDColors.Red.night
    livePulseView.layer.cornerRadius = 8
    livePulseView.isHidden = true

    livePulseView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      livePulseView.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor),
      livePulseView.widthAnchor.constraint(equalToConstant: 46),
      livePulseView.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -16
      ),
      livePulseViewHeightConstraint
    ])

    // Label
    let message = UILabel()
    livePulseView.addSubview(message)
    message.textColor = .white
    message.textAlignment = .center
    message.font = .systemFont(ofSize: 10)
    message.text = "ao vivo"
    
    message.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      message.centerXAnchor.constraint(equalTo: livePulseView.centerXAnchor),
      message.centerYAnchor.constraint(equalTo: livePulseView.centerYAnchor)
    ])
    
    //
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.livePulseView.startPulsating()
    }
  }
}

// MARK: Collection View
extension SpaceyProductCarrouselCollectionViewCell {
  private func configureCollectionView() {
    contentView.addSubview(collectionView)
    collectionView.backgroundColor = .clear
    collectionView.showsHorizontalScrollIndicator = false

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 18),
      collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      collectionViewHeightConstraint
    ])
    
    configureCollectionViewDataSource()
  }
  
  private func configureCollectionViewDataSource() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.headerReferenceSize = CGSize(width: 16, height: collectionView.frame.height)
    
    if isProductCarouselCouponEnabled {
      layout.itemSize = CGSize(width: 175, height: 374)
    } else {
      layout.itemSize = CGSize(width: 300, height: 204)
    }
    
    layout.minimumLineSpacing = 12
    
    collectionView.collectionViewLayout = layout
    
    collectionView.dataSource = self
    collectionView.delegate = self
    
    collectionView.register(SpaceyProductWithCouponOnCarrouselCell.self)
    collectionView.register(SpaceyProductOnCarrouselCell.self)
    
    collectionView.register(
      SpaceyProductLoadingFooterView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: SpaceyProductLoadingFooterView.identifier
    )
    
    collectionView.register(
      SpaceyProductHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: SpaceyProductHeaderView.identifier
    )
  }
}

// MARK: View extension
fileprivate extension UIView {
  func startPulsating() {
    let layerAnim = CALayer()
    layerAnim.frame = self.bounds
    layerAnim.backgroundColor = YDColors.Red.night.cgColor
    layerAnim.cornerRadius = 8

    let layerAnim2 = CALayer()
    layerAnim2.frame = self.bounds
    layerAnim2.backgroundColor = YDColors.Red.night.cgColor
    layerAnim2.cornerRadius = 8

    let fadeOut = CABasicAnimation(keyPath: "opacity")
    fadeOut.fromValue = 0.4
    fadeOut.toValue = 0
    fadeOut.duration = 1.5

    let radiusAnim = CABasicAnimation(keyPath: "cornerRadius")
    radiusAnim.fromValue = 8
    radiusAnim.toValue = [8, 12, 16]
    radiusAnim.duration = 1.5

    let expandScale = CABasicAnimation()
    expandScale.keyPath = "transform"
    expandScale.valueFunction = CAValueFunction(name: CAValueFunctionName.scale)
    expandScale.fromValue = [1, 1, 1]
    expandScale.toValue = [1.5, 2, 1.5]
    expandScale.duration = 1.5

    let fadeAndScale = CAAnimationGroup()
    fadeAndScale.animations = [fadeOut, radiusAnim, expandScale]
    fadeAndScale.duration = 1.5
    fadeAndScale.repeatCount = .infinity
    fadeAndScale.beginTime = CACurrentMediaTime()

    let fadeAndScale2 = CAAnimationGroup()
    fadeAndScale2.animations = [fadeOut, radiusAnim, expandScale]
    fadeAndScale2.duration = 1.5
    fadeAndScale2.repeatCount = .infinity
    fadeAndScale2.beginTime = CACurrentMediaTime() + 0.5

    layerAnim.name = "pulsatingAnimation"
    layerAnim.add(fadeAndScale, forKey: "pulsatingAnimation")
    
    layerAnim2.name = "pulsatingAnimation2"
    layerAnim2.add(fadeAndScale2, forKey: "pulsatingAnimation2")

    layer.insertSublayer(layerAnim, at: 0)
    layer.insertSublayer(layerAnim2, at: 0)
  }

//  func stopPulsating() {
//    layer.removeAnimation(forKey: "pulsatingAnimation")
//    layer.removeAnimation(forKey: "pulsatingAnimation2")
//    layer.sublayers?.removeAll(where: { $0.name == "pulsatingAnimation" })
//    layer.sublayers?.removeAll(where: { $0.name == "pulsatingAnimation2" })
//  }
}

