//
//  SpaceyProductCarrouselCollectionViewCell+DataSource.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 01/10/21.
//

import UIKit

extension SpaceyProductCarrouselCollectionViewCell: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    viewModel?.carrouselProducts[carrouselId]?.items.count ?? 0
  }
  
  // Footer Size
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForFooterInSection section: Int
  ) -> CGSize {
    if !canLoadMore && !isLoading {
      return CGSize(width: 0, height: collectionView.frame.height)
    }
    
    guard let loadingView = loadingView else { return .zero }
    
    // Use this view to calculate the optimal size based on the collection view's width
    return loadingView.systemLayoutSizeFitting(
      CGSize(
        width: UIView.layoutFittingExpandedSize.width,
        height: collectionView.frame.height
      ),
      withHorizontalFittingPriority: .fittingSizeLevel,
      verticalFittingPriority: .required
    )
  }
  
  // Dequeue Header/Footer
  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    if kind == UICollectionView.elementKindSectionFooter {
      guard let aFooterView = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: SpaceyProductLoadingFooterView.identifier,
        for: indexPath
      ) as? SpaceyProductLoadingFooterView else {
        fatalError()
      }
      
      loadingView = aFooterView
      loadingView?.backgroundColor = UIColor.clear
      return aFooterView
    }
    
    let header = collectionView.dequeueReusableSupplementaryView(
      ofKind: kind,
      withReuseIdentifier: SpaceyProductHeaderView.identifier,
      for: indexPath
    )
    
    return header
  }
  
  // Dequeue cell
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let product = viewModel?.carrouselProducts[carrouselId]?.items.at(indexPath.item)
    else {
      fatalError()
    }
    
    if isProductCarouselCouponEnabled {
      let cell: SpaceyProductWithCouponOnCarrouselCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      
      cell.config(with: product)
      
      cell.callbackProductTap = { [weak self] in
        guard let self = self else { return }
        self.viewModel?.selectProductOnCarrousel(product)
      }
      
      cell.callbackAddToCartTap = { [weak self] in
        guard let self = self else { return }
        
        let parameters: [String: Any] = [
          "addToCard": product.onBasket,
          "productId": product.id ?? "",
          "sku": product.ean ?? "",
          "seller": product.partnerId ?? "",
          "skipServiceSelling": true,
          "openCartScreenAfterAdd": false
        ]
        
        self.viewModel?.onAddProductToCart(product, with: parameters)
      }
      
      cell.callbackCouponTap = { [weak self] in
        guard let self = self else { return }
        self.viewModel?.onTapProductCoupon(product)
      }
      
      return cell
      
    } else {
      let cell: SpaceyProductOnCarrouselCell =
      collectionView.dequeueReusableCell(forIndexPath: indexPath)
      
      cell.config(with: product)
      
      cell.callbackProductTap = { [weak self] in
        guard let self = self else { return }
        self.viewModel?.selectProductOnCarrousel(product)
      }
      
      cell.callbackAddToCartTap = { [weak self] in
        guard let self = self else { return }
        
        let parameters: [String: Any] = [
          "addToCard": product.onBasket,
          "productId": product.id ?? "",
          "sku": product.ean ?? "",
          "seller": product.partnerId ?? "",
          "skipServiceSelling": true,
          "openCartScreenAfterAdd": false
        ]
        
        self.viewModel?.onAddProductToCart(product, with: parameters)
      }
      
      return cell
    }
  }
}

// MARK: Flow Layout
extension SpaceyProductCarrouselCollectionViewCell: UICollectionViewDelegateFlowLayout {
  // Will display Footer
  func collectionView(
    _ collectionView: UICollectionView,
    willDisplaySupplementaryView view: UICollectionReusableView,
    forElementKind elementKind: String,
    at indexPath: IndexPath
  ) {
    if elementKind == UICollectionView.elementKindSectionFooter,
       isLoading {
      self.loadingView?.startAnimate()
    }
  }
  
  // Will hide Footer
  func collectionView(
    _ collectionView: UICollectionView,
    didEndDisplayingSupplementaryView view: UICollectionReusableView,
    forElementOfKind elementKind: String,
    at indexPath: IndexPath
  ) {
    if elementKind == UICollectionView.elementKindSectionFooter {
      self.loadingView?.stopAnimate()
    }
  }
  
  // Will display cell
  func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    if indexPath.item == collectionView.numberOfItems(inSection: 0) - 1,
       canLoadMore {
      canLoadMore = false
      loadMoreProducts()
    }
  }
}
