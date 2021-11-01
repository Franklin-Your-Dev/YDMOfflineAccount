//
//  YDMFindStoreViewController+CollectionView.swift
//  YDMFindStore
//
//  Created by Douglas Hennrich on 11/12/20.
//

import UIKit

import YDExtensions

// MARK: Data Source
extension YDMFindStoreViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let stores = viewModel?.stores.value else {
      if collectionView == self.collectionView {
        storesListContainer.isHidden = true
      }
      return 0
    }

    if collectionView == self.collectionView {
      storesListContainer.isHidden = stores.isEmpty
    }

    return stores.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YDMFindStoreStoreCardCollectionViewCell.identifier, for: indexPath) as? YDMFindStoreStoreCardCollectionViewCell,
          let viewModel = viewModel,
          let store = viewModel[indexPath.row]
    else {
      fatalError()
    }

    cell.config(with: store)
    cell.callback = { fromProducts in
      viewModel.onStoreCardAction(type: fromProducts ? .product : .whatsapp, store: store)
    }
    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    switch kind {

    case UICollectionView.elementKindSectionHeader:
      let headerView = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: "Header",
        for: indexPath
      )
      return headerView

    case UICollectionView.elementKindSectionFooter:
      let footerView = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: "Footer",
        for: indexPath
      )
      return footerView

    default:
      fatalError("Header Section")
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    if collectionView == verticalCollectionView {
      return CGSize(width: verticalCardWidthSize, height: 156)
    }

    return CGSize(width: cardWidthSize, height: 156)
  }
}

// MARK: Delegate
extension YDMFindStoreViewController: UICollectionViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if reAdjustinRect { return }
    reAdjustinRect = true

    let cells = collectionView.visibleCells
    let currentX = scrollView.contentOffset.x
    var items: [(UICollectionViewCell, IndexPath)] = []

    for item in cells {
      if let indexPath = collectionView.indexPath(for: item) {
        items.append((item, indexPath))
      }
    }

    if let closest = items.enumerated().min(by: {
      abs($0.element.0.frame.minX - currentX) < abs($1.element.0.frame.minX - currentX)
    }) {
      collectionView.scrollToItem(at: closest.element.1, at: .centeredHorizontally, animated: true)

      redrawPins(highlightAt: closest.element.1.row, shouldCenterMap: true)
    }

    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
      self?.reAdjustinRect = false
    }
  }
}
