//
//  SpaceyViewController+CollectionDelegate.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 03/10/21.
//

import UIKit

// MARK: UICollection Delegate
extension YDSpaceyViewController: UICollectionViewDelegate {
  public func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    guard let itemAndType = viewModel?.getComponentAndType(at: indexPath),
          let component = itemAndType.component,
          let item = component.children.first
    else {
      return
    }

    if case .banner(let banner) = item {
      viewModel?.onOpenBanner(with: banner.deepLink)
    }
  }
  
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    delegate?.scrollViewDidScroll(scrollView)
  }
}

// MARK: Flow Delegate
extension YDSpaceyViewController: UICollectionViewDelegateFlowLayout {
  // Header Size
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    return CGSize(width: 0, height: largerHeader ? 40 : 20)
  }

  // Item Size
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
    let referenceHeight: CGFloat = 100
    let referenceWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width
      - sectionInset.left
      - sectionInset.right
      - collectionView.contentInset.left
      - collectionView.contentInset.right
    return CGSize(width: referenceWidth, height: referenceHeight)
  }
}
