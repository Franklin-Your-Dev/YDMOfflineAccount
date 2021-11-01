//
//  SpaceyBannerCarrouselCollectionViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 12/05/21.
//

import UIKit

import YDB2WModels
import YDExtensions

class SpaceyBannerCarrouselCollectionViewCell: UICollectionViewCell {
  // MARK: Properties
  var viewModel: YDSpaceyViewModelDelegate?
  var carrouselId: Int = 0
  var previousItemsCount = 0

  var collectionViewOffset: CGFloat {
    get {
      return collectionView.contentOffset.x
    }
    set {
      collectionView.contentOffset.x = newValue
    }
  }

  // MARK: Components
  lazy var width: NSLayoutConstraint = {
      let width = contentView.widthAnchor
        .constraint(equalToConstant: bounds.size.width)
      width.isActive = true
      return width
  }()

  let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout()
  )

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

    clipsToBounds = false
    layer.masksToBounds = false
    contentView.clipsToBounds = false
    contentView.layer.masksToBounds = false
  }

  // MARK: Configure
  func configure(
    with carrouselId: Int,
    viewModel: YDSpaceyViewModelDelegate?
  ) {
    guard let component = viewModel?.componentsList
            .value.at(carrouselId)?.component as? YDSpaceyComponentCarrouselBanner
    else {
      return
    }

    self.carrouselId = carrouselId
    self.viewModel = viewModel

    configureCollectionViewLayout(
      maxItemsOnScreen: component.itemsToShowOnScreen
    )

    collectionView.reloadData()

    if let currentX = component.currentRectList {
      collectionViewOffset = currentX
    } else {
      collectionViewOffset = 0
    }
  }
}

// MARK: Actions
extension SpaceyBannerCarrouselCollectionViewCell {
  func getBannerComponent(at indexPath: IndexPath) -> YDSpaceyComponentBanner? {
    guard viewModel?.componentsList.value.at(carrouselId) != nil,
          let component = viewModel?.componentsList.value[carrouselId].component as?
            YDSpaceyComponentCarrouselBanner,
          case .banner(let banner) = component.children.at(indexPath.item)
    else {
      return nil
    }
    
    return banner
  }
}

// MARK: Layouts
extension SpaceyBannerCarrouselCollectionViewCell {
  func configureLayout() {
    configureCollectionView()
  }

  func configureCollectionView() {
    contentView.addSubview(collectionView)
    collectionView.backgroundColor = .clear
    collectionView.showsHorizontalScrollIndicator = false

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])

    collectionView.dataSource = self
    collectionView.delegate = self

    // Register Cell
    collectionView.register(
      SpaceyBannerOnCarrouselCell.self,
      forCellWithReuseIdentifier: SpaceyBannerOnCarrouselCell.identifier
    )
  }

  func configureCollectionViewLayout(maxItemsOnScreen: Double) {
    let screenPadding: CGFloat = 16
    let convertedToFloat = CGFloat(maxItemsOnScreen)
    let itemSize = (frame.size.width / convertedToFloat).rounded(.up)

    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.minimumLineSpacing = 12

    flowLayout.itemSize = CGSize(
      width: itemSize,
      height: itemSize
    )

    flowLayout.sectionInset = UIEdgeInsets(
      top: 0,
      left: screenPadding,
      bottom: 0,
      right: screenPadding
    )

    collectionView.collectionViewLayout = flowLayout
    collectionView.heightAnchor.constraint(equalToConstant: itemSize).isActive = true
  }
}
