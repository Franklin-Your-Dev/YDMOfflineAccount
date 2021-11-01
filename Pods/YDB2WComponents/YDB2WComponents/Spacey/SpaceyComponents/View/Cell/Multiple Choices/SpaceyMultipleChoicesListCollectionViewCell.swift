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
  let titleLabel = UILabel()
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
    titleLabel.text = component.question
    choices = component.childrenAnswers
    collectionView.reloadData()
    height.constant = 140
  }
}

// MARK: Layout
extension SpaceyMultipleChoicesListCollectionViewCell {
  func configureLayout() {
    configureTitleLabel()
    configureCollectionView()
  }

  func configureTitleLabel() {
    contentView.addSubview(titleLabel)
    titleLabel.font = .systemFont(ofSize: 14)
    titleLabel.textColor = YDColors.black
    titleLabel.textAlignment = .left

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
      titleLabel.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor,
        constant: 16
      ),
      titleLabel.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -16
      ),
      titleLabel.heightAnchor.constraint(equalToConstant: 16)
    ])
  }

  func configureCollectionView() {
    contentView.addSubview(collectionView)
    collectionView.backgroundColor = .clear
    collectionView.showsVerticalScrollIndicator = false

    let layout = UICollectionViewFlowLayout()
    layout.estimatedItemSize = CGSize(width: width.constant, height: 30)
    layout.minimumLineSpacing = 8
    layout.scrollDirection = .vertical
    collectionView.collectionViewLayout = layout

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(
        equalTo: titleLabel.bottomAnchor,
        constant: 12
      ),
      collectionView.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor
      ),
      collectionView.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor
      ),
      collectionView.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor
      )
    ])
    height.constant = 130

    collectionView.delegate = self
    collectionView.dataSource = self

    // Register Cell
    collectionView.register(
      SpaceyMultipleChoicesCollectionViewCell.self,
      forCellWithReuseIdentifier: SpaceyMultipleChoicesCollectionViewCell.identifier
    )
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
    guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SpaceyMultipleChoicesCollectionViewCell.identifier,
            for: indexPath
    ) as? SpaceyMultipleChoicesCollectionViewCell,
    let choice = choices.at(indexPath.row)
    else {
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

