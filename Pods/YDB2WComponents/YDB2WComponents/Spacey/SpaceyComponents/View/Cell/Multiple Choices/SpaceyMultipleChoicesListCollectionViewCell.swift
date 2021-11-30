//
//  SpaceyMultipleChoicesListCollectionViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 26/05/21.
//

import UIKit

import YDExtensions
import YDB2WModels
import YDB2WColors

class SpaceyMultipleChoicesListCollectionViewCell: UICollectionViewCell {
  // MARK: Components
  lazy var width: NSLayoutConstraint = {
    let width = contentView.widthAnchor
      .constraint(equalToConstant: bounds.size.width)
    width.isActive = true
    return width
  }()
  
  let containerView = UIView()
  
  let titleWithOptionalView = YDSpaceyNPSTitleWithOptionalView()
  
  let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout()
  )
  lazy var height: NSLayoutConstraint = {
    let height = collectionView.heightAnchor.constraint(equalToConstant: 130)
    height.isActive = true
    return height
  }()

  // MARK: Properties
  private let padding: CGFloat = 16
  var choices: [YDSpaceyComponentNPSQuestionAnswer] = []
  var callback: ((_ choices: [YDSpaceyComponentNPSQuestionAnswer]) -> Void)?

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

  override func layoutSubviews() {
    super.layoutSubviews()
    height.constant = collectionView.contentSize.height
  }

  // MARK: Configure
  func configure(with component: YDSpaceyComponentNPSQuestion) {
    titleWithOptionalView.configure(with: component)
    
    choices = component.childrenAnswers
    collectionView.reloadData()
    height.constant = 140
  }
}

// MARK: Layout
extension SpaceyMultipleChoicesListCollectionViewCell {
  func configureLayout() {
    configureContainerView()
    configureTitleWithOptionalView()
    configureCollectionView()
  }
  
  private func configureContainerView() {
    contentView.addSubview(containerView)
    containerView.backgroundColor = .white
    containerView.layer.cornerRadius = 12
    containerView.layer.applyShadow(y: 1, blur: 8, spread: -1)
    
    containerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
      containerView.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor,
        constant: padding
      ),
      containerView.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -padding
      ),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
    ])
  }
  
  private func configureTitleWithOptionalView() {
    containerView.addSubview(titleWithOptionalView)
    
    NSLayoutConstraint.activate([
      titleWithOptionalView.topAnchor.constraint(
        equalTo: containerView.topAnchor,
        constant: padding
      ),
      titleWithOptionalView.leadingAnchor.constraint(
        equalTo: containerView.leadingAnchor,
        constant: padding
      ),
      titleWithOptionalView.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor,
        constant: -padding
      )
    ])
  }

  func configureCollectionView() {
    containerView.addSubview(collectionView)
    collectionView.backgroundColor = .clear
    collectionView.showsVerticalScrollIndicator = false

    let layout = SpaceyMultipleChoicesFlow()
    layout.estimatedItemSize = CGSize(width: 50, height: 34)
    layout.minimumLineSpacing = 8
    layout.minimumInteritemSpacing = 16
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(
      top: 0,
      left: 16,
      bottom: 0,
      right: 16
    )
    collectionView.collectionViewLayout = layout

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(
        equalTo: titleWithOptionalView.bottomAnchor,
        constant: 14
      ),
      collectionView.leadingAnchor.constraint(
        equalTo: containerView.leadingAnchor
      ),
      collectionView.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor
      ),
      collectionView.bottomAnchor.constraint(
        equalTo: containerView.bottomAnchor,
        constant: -12
      )
    ])
    height.constant = 130

    collectionView.delegate = self
    collectionView.dataSource = self

    // Register Cell
    collectionView.register(SpaceyCommonOptionCell.self)
  }
}

// MARK: UICollection DataSource
extension SpaceyMultipleChoicesListCollectionViewCell: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return choices.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: SpaceyCommonOptionCell = collectionView.dequeueReusableCell(
      forIndexPath: indexPath
    )
    
    guard let choice = choices.at(indexPath.item) else {
      fatalError()
    }

    cell.configure(with: choice)
    return cell
  }
}

// MARK: UICollection Delegate
extension SpaceyMultipleChoicesListCollectionViewCell: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    for(index, item) in choices.enumerated() {
      item.selected = index == indexPath.row
    }

    collectionView.reloadData()
    callback?(choices)
  }
}
