//
//  SpaceyGridCollectionViewCell+DataSource.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 07/06/21.
//

import UIKit
import YDExtensions
import YDB2WModels

extension SpaceyGridCollectionViewCell: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return items.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard !items.isEmpty,
          let item = items.at(indexPath.item) else {
      fatalError("Grid -> items at \(indexPath.item)")
    }

    switch item {
      case .banner(let component):
        return dequeueBannerCell(with: component, at: indexPath)

      case .grid(let component):
        return dequeueGridCell(with: component, at: indexPath)

      case .title(let component):
        return dequeueTitleCell(with: component, at: indexPath)

      default:
        fatalError("\(item.componentType) isn't supported yet")
    }
  }

//  func collectionView(
//    _ collectionView: UICollectionView,
//    layout collectionViewLayout: UICollectionViewLayout,
//    sizeForItemAt indexPath: IndexPath
//  ) -> CGSize {
//    let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
//    let referenceHeight: CGFloat = 50
//    let referenceWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width
//      - sectionInset.left
//      - sectionInset.right
//      - collectionView.contentInset.left
//      - collectionView.contentInset.right
//    return CGSize(width: referenceWidth, height: referenceHeight)
//  }
}

// MARK: Banner
extension SpaceyGridCollectionViewCell {
  func dequeueBannerCell(
    with component: YDSpaceyComponentBanner,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: SpaceyBannerCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

    cell.config(with: component)
    cell.needsToUpdateCallback = { [weak self] in
      guard let self = self else { return }
      self.collectionView.setNeedsLayout()
    }
    return cell
  }
}

// MARK: Title
extension SpaceyGridCollectionViewCell {
  func dequeueTitleCell(
    with title: YDSpaceyComponentTitle,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: SpaceyTitleCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    cell.configure(withTitle: title.contentTitle)
    return cell
  }
}

// MARK: Grid
extension SpaceyGridCollectionViewCell {
  func dequeueGridCell(
    with component: YDSpaceyComponentGrid,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: SpaceyGridCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    cell.configure(with: component)
    return cell
  }
}
