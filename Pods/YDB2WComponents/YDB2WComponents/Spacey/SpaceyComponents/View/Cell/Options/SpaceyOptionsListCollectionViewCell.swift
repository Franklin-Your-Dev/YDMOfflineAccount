//
//  SpaceyOptionsListCollectionViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 20/05/21.
//

import UIKit

import YDExtensions
import YDB2WModels
import YDB2WColors

class SpaceyOptionsListCollectionViewCell: UICollectionViewCell {
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
      constant: padding
    )
  }()
  lazy var containerTrailingConstraint: NSLayoutConstraint = {
    containerView.trailingAnchor.constraint(
      equalTo: contentView.trailingAnchor,
      constant: -padding
    )
  }()
  lazy var containerBottomConstraint: NSLayoutConstraint = {
    containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
  }()
  
  let titleLabel = UILabel()
  lazy var titleLabelTopConstraint: NSLayoutConstraint = {
    titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding)
  }()
  
  let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout()
  )
  lazy var collectionViewBottomConstraint: NSLayoutConstraint = {
    collectionView.bottomAnchor.constraint(
      equalTo: containerView.bottomAnchor,
      constant: -12
    )
  }()

  // MARK: Properties
  private let padding: CGFloat = 16
  var options: [YDSpaceyComponentNPSQuestionAnswer] = []
  var callback: ((_ options: [YDSpaceyComponentNPSQuestionAnswer]) -> Void)?

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    configureLayout()
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

  // MARK: Configure
  func configure(with component: YDSpaceyComponentNPSQuestion) {
    toggleCardStyle(itsCard: !component.itsFromPreview)
    
    titleLabel.text = component.question
    options = component.childrenAnswers
    collectionView.reloadData()
  }
  
  private func toggleCardStyle(itsCard: Bool) {
    if itsCard {
      containerView.layer.applyShadow(y: 1, blur: 8, spread: -1)
      containerTopConstraint.constant = 2
      containerLeadingConstraint.constant = 16
      containerTrailingConstraint.constant = -16
      containerBottomConstraint.constant = -2
      
      titleLabelTopConstraint.constant = padding
      collectionViewBottomConstraint.constant = -12
      
    } else {
      containerView.layer.shadowOpacity = 0
      containerTopConstraint.constant = 0
      containerLeadingConstraint.constant = 0
      containerTrailingConstraint.constant = 0
      containerBottomConstraint.constant = 0
      
      titleLabelTopConstraint.constant = 0
      collectionViewBottomConstraint.constant = 0
    }
    
    contentView.layoutIfNeeded()
  }
}

// MARK: Layout
extension SpaceyOptionsListCollectionViewCell {
  func configureLayout() {
    configureContainerView()
    configureTitleLabel()
    configureCollectionView()
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

  func configureTitleLabel() {
    containerView.addSubview(titleLabel)
    titleLabel.font = .boldSystemFont(ofSize: 14)
    titleLabel.textColor = YDColors.Gray.medium
    titleLabel.textAlignment = .left

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabelTopConstraint,
      titleLabel.leadingAnchor.constraint(
        equalTo: containerView.leadingAnchor,
        constant: padding
      ),
      titleLabel.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor,
        constant: -padding
      ),
      titleLabel.heightAnchor.constraint(equalToConstant: 16)
    ])
  }

  func configureCollectionView() {
    containerView.addSubview(collectionView)
    collectionView.backgroundColor = .clear
    collectionView.showsHorizontalScrollIndicator = false

    let layout = UICollectionViewFlowLayout()
    layout.estimatedItemSize = CGSize(width: 50, height: 34)
    layout.minimumLineSpacing = 16
    layout.sectionInset = UIEdgeInsets(
      top: 0,
      left: 16,
      bottom: 0,
      right: 16
    )
    layout.scrollDirection = .horizontal
    collectionView.collectionViewLayout = layout

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(
        equalTo: titleLabel.bottomAnchor,
        constant: 14
      ),
      collectionView.leadingAnchor.constraint(
        equalTo: containerView.leadingAnchor
      ),
      collectionView.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor
      ),
      collectionViewBottomConstraint,
      collectionView.heightAnchor.constraint(equalToConstant: 42)
    ])

    collectionView.delegate = self
    collectionView.dataSource = self

    // Register Cell
    collectionView.register(SpaceyCommonOptionCell.self)
  }
}

// MARK: UICollection DataSource
extension SpaceyOptionsListCollectionViewCell: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return options.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: SpaceyCommonOptionCell = collectionView.dequeueReusableCell(
      forIndexPath: indexPath
    )
    
    guard let option = options.at(indexPath.row) else {
      fatalError()
    }

    cell.configure(with: option)
    return cell
  }
}

// MARK: UICollection Delegate
extension SpaceyOptionsListCollectionViewCell: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    for(index, item) in options.enumerated() {
      item.selected = index == indexPath.row
    }

    collectionView.reloadData()
    callback?(options)
  }
}
