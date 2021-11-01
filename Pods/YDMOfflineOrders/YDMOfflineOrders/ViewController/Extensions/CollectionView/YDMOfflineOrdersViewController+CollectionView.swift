//
//  YDMOfflineOrdersViewController+CollectionView.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 22/02/21.
//

import UIKit

import YDExtensions
import YDB2WComponents
import YDB2WModels

// MARK: Actions
extension YDMOfflineOrdersViewController {
  func addNewOrders() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self,
            let viewModel = self.viewModel,
            !viewModel.noMoreOrderToLoad
      else { return }
      
      self.collectionView.reloadData()
      self.canLoadMore = !viewModel.noMoreOrderToLoad
    }
  }
  
  func dequeueCell(
    at indexPath: IndexPath,
    collectionView: UICollectionView
  ) -> UICollectionViewCell {
    if loadingShimmer {
      if indexPath.item == 0 {
        return dequeueHeaderCell(
          at: indexPath,
          withConfig: nil,
          collectionView: collectionView
        )
      } else {
        return dequeueOrderCell(at: indexPath, withOrder: nil)
      }
    }
    
    guard let config = viewModel?.orderList.value.at(indexPath.item)
    else {
      fatalError("dequeueCell")
    }
    
    switch config.type {
      case .header:
        return dequeueHeaderCell(
          at: indexPath,
          withConfig: config,
          collectionView: collectionView
        )
      case .row:
        return dequeueOrderCell(at: indexPath, withOrder: config.order)
    }
  }
  
  // Header cell
  func dequeueHeaderCell(
    at indexPath: IndexPath,
    withConfig config: OrderListConfig?,
    collectionView: UICollectionView
  ) -> UICollectionViewCell {
    let cell: OrdersHeaderCollectionViewCell = collectionView
      .dequeueReusableCell(forIndexPath: indexPath)
    
    cell.dateLabel.text = config?.headerString
    return cell
  }
  
  // Order cell
  func dequeueOrderCell(
    at indexPath: IndexPath,
    withOrder order: YDOfflineOrdersOrder?
  ) -> UICollectionViewCell {
    let cell: OrdersCollectionViewCell = collectionView
      .dequeueReusableCell(forIndexPath: indexPath)
    
    if loadingShimmer {
      cell.config(shimmer: true)
      return cell
    }
    
    guard let order = order
    else {
      fatalError("Dequeue OrdersCollectionViewCell")
    }
    
    cell.config(with: order)
    
    cell.productCallback = { [weak self] product in
      guard let self = self else { return }
      self.viewModel?.openDetailsForProduct(product, withinOrder: order)
    }
    
    cell.orderDetailsCallback = { [weak self] in
      guard let self = self else { return }
      self.viewModel?.openDetailsForOrder(order)
    }
    
    cell.noteCallback = { [weak self] in
      guard let self = self else { return }
      self.viewModel?.openInvoice(for: order)
    }
    
    // Load more content logic
    if indexPath.item == (
      collectionView.numberOfItems(inSection: indexPath.section) - 1
    ) {
      loadMoreFunc()
    }
    
    return cell
  }
}

// MARK: Data Source
extension YDMOfflineOrdersViewController: UICollectionViewDataSource {
  // Number of Items
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    if loadingShimmer {
      return numberOfShimmers ?? 1
    }
    
    return viewModel?.orderList.value.count ?? 0
  }
  
  // Dequeue Item
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return dequeueCell(at: indexPath, collectionView: collectionView)
  }
  
  // Header / Footer
  public func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    switch kind {
      case UICollectionView.elementKindSectionHeader:
        guard let header = collectionView.dequeueReusableSupplementaryView(
          ofKind: UICollectionView.elementKindSectionHeader,
          withReuseIdentifier: OrdersCollectionFooterReusableView.identifier,
          for: indexPath
        ) as? OrdersCollectionFooterReusableView
        else {
          fatalError("viewForSupplementaryElementOfKind: OrdersCollectionFooterReusableView")
        }
        
        return header
        
      case UICollectionView.elementKindSectionFooter:
        guard let footer = collectionView.dequeueReusableSupplementaryView(
          ofKind: UICollectionView.elementKindSectionFooter,
          withReuseIdentifier: OrdersLoadingCollectionFooterReusableView.identifier,
          for: indexPath
        ) as? OrdersLoadingCollectionFooterReusableView
        else {
          fatalError("viewForSupplementaryElementOfKind: OrdersLoadingCollectionFooterReusableView")
        }
        
        if loadingShimmer {
          return footer
        }
        
        if loadMoreShimmer == nil {
          loadMoreShimmer = footer
          return footer
        }
        
        return loadMoreShimmer!
        
      default:
        fatalError("viewForSupplementaryElementOfKind")
    }
  }
  
  // Will display Footer
  public func collectionView(
    _ collectionView: UICollectionView,
    willDisplaySupplementaryView view: UICollectionReusableView,
    forElementKind elementKind: String,
    at indexPath: IndexPath
  ) {
    if loadingShimmer ||
        elementKind == UICollectionView.elementKindSectionHeader { return }
    
    if viewModel?.noMoreOrderToLoad == false {
      if canLoadMore {
        canLoadMore = false
        viewModel?.getMoreOrders()
      }
      
    } else {
      // hide shimmer
      //      loadMoreShimmer?.stopShimmerAndHide()
      //      collectionView.collectionViewLayout.invalidateLayout()
    }
  }
}

// MARK: Data Flow Delegate
extension YDMOfflineOrdersViewController: UICollectionViewDelegateFlowLayout {
  // Item size
  //  public func collectionView(
  //    _ collectionView: UICollectionView,
  //    layout collectionViewLayout: UICollectionViewLayout,
  //    sizeForItemAt indexPath: IndexPath
  //  ) -> CGSize {
  //    if collectionView == shimmerCollectionView {
  //      return indexPath.row == 0 ?
  //        CGSize(width: view.frame.size.width, height: 40) :
  //        CGSize(width: view.frame.size.width, height: 235)
  //    }
  //
  //    guard let config = viewModel?[indexPath.row] else { return .zero }
  //    return config.type == .header ?
  //      CGSize(width: view.frame.size.width, height: 40) :
  //      CGSize(width: view.frame.size.width, height: 235)
  //  }
  
  // Footer Size
//  public func collectionView(
//    _ collectionView: UICollectionView,
//    layout collectionViewLayout: UICollectionViewLayout,
//    referenceSizeForFooterInSection section: Int
//  ) -> CGSize {
//    if viewModel?.noMoreOrderToLoad == true {
//      return CGSize(width: view.frame.size.width, height: 20)
//    }
//
//    return CGSize(width: 1, height: 1)
//  }
}
