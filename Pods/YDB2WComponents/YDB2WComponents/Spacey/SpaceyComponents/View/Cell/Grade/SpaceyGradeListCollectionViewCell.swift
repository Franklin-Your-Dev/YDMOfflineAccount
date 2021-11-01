//
//  SpaceyGradeListCollectionViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 26/05/21.
//

import UIKit

import YDExtensions
import YDB2WModels
import YDB2WColors

class SpaceyGradeListCollectionViewCell: UICollectionViewCell {
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

  // MARK: Properties
  var grades: [YDSpaceyComponentNPSQuestionAnswer] = []
  var callback: ((_ grades: [YDSpaceyComponentNPSQuestionAnswer]) -> Void)?

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
    titleLabel.text = component.question
    grades = component.childrenAnswers
    collectionView.reloadData()
  }
}

// MARK: Layout
extension SpaceyGradeListCollectionViewCell {
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
    collectionView.showsHorizontalScrollIndicator = false

    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 30, height: 30)
    layout.minimumLineSpacing = 8
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
      ),
      collectionView.heightAnchor.constraint(equalToConstant: 30)
    ])

    collectionView.delegate = self
    collectionView.dataSource = self

    // Register Cell
    collectionView.register(
      SpaceyGradeCollectionViewCell.self,
      forCellWithReuseIdentifier: SpaceyGradeCollectionViewCell.identifier
    )
  }
}

// MARK: UICollection DataSource
extension SpaceyGradeListCollectionViewCell: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return grades.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SpaceyGradeCollectionViewCell.identifier,
            for: indexPath
    ) as? SpaceyGradeCollectionViewCell,
    let grade = grades.at(indexPath.row)
    else {
      fatalError()
    }

    cell.configure(with: grade)
    return cell
  }
}

// MARK: UICollection Delegate
extension SpaceyGradeListCollectionViewCell: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    for(index, item) in grades.enumerated() {
      item.selected = index == indexPath.row
    }

    collectionView.reloadData()
    callback?(grades)
  }
}
