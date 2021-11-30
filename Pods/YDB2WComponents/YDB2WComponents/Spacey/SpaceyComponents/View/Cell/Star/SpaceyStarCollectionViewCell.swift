//
//  SpaceyStarCollectionViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 20/05/21.
//

import UIKit

import YDB2WModels

class SpaceyStarCollectionViewCell: UICollectionViewCell {
  // MARK: Components
  lazy var width: NSLayoutConstraint = {
    let width = contentView.widthAnchor
      .constraint(equalToConstant: bounds.size.width)
    width.isActive = true
    return width
  }()
  
  let containerView = UIView()
  lazy var containerTopConstraint: NSLayoutConstraint = {
    containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2)
  }()
  lazy var containerLeadingConstraint: NSLayoutConstraint = {
    containerView.leadingAnchor.constraint(
      equalTo: contentView.leadingAnchor,
      constant: 16
    )
  }()
  lazy var containerTrailingConstraint: NSLayoutConstraint = {
    containerView.trailingAnchor.constraint(
      equalTo: contentView.trailingAnchor,
      constant: -16
    )
  }()
  lazy var containerBottomConstraint: NSLayoutConstraint = {
    containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
  }()
  
  let starComponent = SpaceyStarComponentView()
  lazy var starComponentTopConstraint: NSLayoutConstraint = {
    starComponent.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8)
  }()
  lazy var starComponentBottomConstraint: NSLayoutConstraint = {
    starComponent.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
  }()

  // MARK: Properties
  var starNumber: Double {
    get {
      starComponent.starNumber
    }
    set {
      starComponent.starNumber = newValue
    }
  }
  var callback: ((_ starNumber: Double) -> Void)? {
    didSet {
      starComponent.callback = callback
    }
  }

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
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
    callback = nil
    toggleCardStyle(itsCard: true)
    
    super.prepareForReuse()
  }

  // MARK: Configure
  func configure(with component: YDSpaceyComponentNPSQuestion) {
    toggleCardStyle(itsCard: !component.itsFromPreview)
    
    starComponent.configure(with: component)
  }
  
  private func toggleCardStyle(itsCard: Bool) {
    if itsCard {
      containerView.layer.applyShadow(y: 1, blur: 8, spread: -1)
      containerTopConstraint.constant = 2
      containerLeadingConstraint.constant = 16
      containerTrailingConstraint.constant = -16
      containerBottomConstraint.constant = -2
      
      starComponentTopConstraint.constant = 8
      starComponentBottomConstraint.constant = -12
      
    } else {
      containerView.layer.shadowOpacity = 0
      containerTopConstraint.constant = 0
      containerLeadingConstraint.constant = 0
      containerTrailingConstraint.constant = 0
      containerBottomConstraint.constant = 0
      
      starComponentTopConstraint.constant = 0
      starComponentBottomConstraint.constant = 0
    }
    
    contentView.layoutIfNeeded()
  }
}

// MARK: Layout
extension SpaceyStarCollectionViewCell {
  private func configureUI() {
    contentView.translatesAutoresizingMaskIntoConstraints = false
    
    configureContainerView()
    configureStarComponent()
  }
  
  private func configureContainerView() {
    contentView.addSubview(containerView)
    containerView.backgroundColor = .white
    containerView.layer.cornerRadius = 12
    containerView.layer.applyShadow(y: 1, blur: 8, spread: -1)
    
    containerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerTopConstraint,
      containerLeadingConstraint,
      containerTrailingConstraint,
      containerBottomConstraint
    ])
  }
  
  func configureStarComponent() {
    contentView.addSubview(starComponent)

    NSLayoutConstraint.activate([
      starComponentTopConstraint,
      starComponent.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor,
        constant: 16
      ),
      starComponent.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -16
      ),
      starComponentBottomConstraint
    ])
  }
}
