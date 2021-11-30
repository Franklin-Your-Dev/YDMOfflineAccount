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
  
  let titleLabel = UILabel()
  lazy var titleLabelTopConstraint: NSLayoutConstraint = {
    titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8)
  }()
  
  let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout()
  )
  
  let lowerGradeLabel = UILabel()
  lazy var lowerGradeHeightConstraint: NSLayoutConstraint = {
    let height = lowerGradeLabel.heightAnchor.constraint(equalToConstant: 14)
    return height
  }()
  lazy var lowerGradeBottomConstraint: NSLayoutConstraint = {
    lowerGradeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
  }()
  
  let higherGradeLabel = UILabel()
  lazy var higherGradeHeightConstraint: NSLayoutConstraint = {
    let height = higherGradeLabel.heightAnchor.constraint(equalToConstant: 14)
    return height
  }()
  lazy var higherGradeBottomConstraint: NSLayoutConstraint = {
    higherGradeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
  }()

  // MARK: Properties
  var grades: [YDSpaceyComponentNPSQuestionAnswer] = []
  var callback: ((_ grades: [YDSpaceyComponentNPSQuestionAnswer]) -> Void)?

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
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
  
  override func prepareForReuse() {
    lowerGradeLabel.text = nil
    higherGradeLabel.text = nil
    lowerGradeHeightConstraint.constant = 0
    higherGradeHeightConstraint.constant = 0
    grades = []
    titleLabel.text = nil
    toggleCardStyle(itsCard: true)
    
    super.prepareForReuse()
  }

  // MARK: Configure
  func configure(with component: YDSpaceyComponentNPSQuestion) {
    toggleCardStyle(itsCard: !component.itsFromPreview)
    
    titleLabel.text = component.question
    grades = component.childrenAnswers
    
    if let lower = component.lowerGradeText {
      lowerGradeLabel.text = lower
      lowerGradeHeightConstraint.constant = 14
    } else {
      lowerGradeHeightConstraint.constant = 0
    }
    
    if let higher = component.higherGradeText {
      higherGradeLabel.text = higher
      higherGradeHeightConstraint.constant = 14
    } else {
      higherGradeHeightConstraint.constant = 0
    }
    
    collectionView.reloadData()
  }
  
  private func toggleCardStyle(itsCard: Bool) {
    if itsCard {
      containerView.layer.applyShadow(y: 1, blur: 8, spread: -1)
      containerTopConstraint.constant = 2
      containerLeadingConstraint.constant = 16
      containerTrailingConstraint.constant = -16
      containerBottomConstraint.constant = -2
      
      titleLabelTopConstraint.constant = 8
      lowerGradeBottomConstraint.constant = -12
      higherGradeBottomConstraint.constant = -12
      
    } else {
      containerView.layer.shadowOpacity = 0
      containerTopConstraint.constant = 0
      containerLeadingConstraint.constant = 0
      containerTrailingConstraint.constant = 0
      containerBottomConstraint.constant = 0
      
      titleLabelTopConstraint.constant = 0
      lowerGradeBottomConstraint.constant = 0
      higherGradeBottomConstraint.constant = 0
    }
    
    contentView.layoutIfNeeded()
  }
}

// MARK: Layout
extension SpaceyGradeListCollectionViewCell {
  func configureLayout() {
    contentView.translatesAutoresizingMaskIntoConstraints = false
    
    configureContainerView()
    configureTitleLabel()
    configureCollectionView()
    configureLowerGradeLabel()
    configureHigherGradeLabel()
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

  private func configureTitleLabel() {
    containerView.addSubview(titleLabel)
    titleLabel.font = .boldSystemFont(ofSize: 14)
    titleLabel.textColor = YDColors.Gray.medium
    titleLabel.textAlignment = .left

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabelTopConstraint,
      titleLabel.leadingAnchor.constraint(
        equalTo: containerView.leadingAnchor,
        constant: 16
      ),
      titleLabel.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor,
        constant: -16
      ),
      titleLabel.heightAnchor.constraint(equalToConstant: 16)
    ])
  }

  private func configureCollectionView() {
    containerView.addSubview(collectionView)
    collectionView.backgroundColor = .clear
    collectionView.showsHorizontalScrollIndicator = false

    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 22, height: 22)
    layout.minimumLineSpacing = 10
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
        constant: 8
      ),
      collectionView.leadingAnchor.constraint(
        equalTo: containerView.leadingAnchor
      ),
      collectionView.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor
      ),
      collectionView.heightAnchor.constraint(equalToConstant: 22)
    ])

    collectionView.delegate = self
    collectionView.dataSource = self

    // Register Cell
    collectionView.register(
      SpaceyGradeCollectionViewCell.self,
      forCellWithReuseIdentifier: SpaceyGradeCollectionViewCell.identifier
    )
  }
  
  private func configureLowerGradeLabel() {
    containerView.addSubview(lowerGradeLabel)
    lowerGradeLabel.font = .systemFont(ofSize: 12)
    lowerGradeLabel.textAlignment = .left
    lowerGradeLabel.textColor = YDColors.black
    
    lowerGradeLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      lowerGradeLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 6),
      lowerGradeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
      lowerGradeBottomConstraint,
      lowerGradeHeightConstraint
    ])
  }
  
  private func configureHigherGradeLabel() {
    containerView.addSubview(higherGradeLabel)
    higherGradeLabel.font = .systemFont(ofSize: 12)
    higherGradeLabel.textAlignment = .right
    higherGradeLabel.textColor = YDColors.black
    
    higherGradeLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      higherGradeLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 6),
      higherGradeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
      higherGradeBottomConstraint,
      higherGradeHeightConstraint
    ])
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
