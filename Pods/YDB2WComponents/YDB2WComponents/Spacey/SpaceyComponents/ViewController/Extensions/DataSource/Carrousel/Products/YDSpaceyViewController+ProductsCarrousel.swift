//
//  YDSpaceyViewController+ProductsCarrousel.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 13/05/21.
//

import UIKit

import YDB2WModels

extension YDSpaceyViewController {
  func getProductsIds(
    at row: Int,
    onCompletion: @escaping ([ (id: String, sellerId: String) ]) -> Void
  ) {
    viewModel?.getProductsIds(at: row, onCompletion: onCompletion)
  }
  
  func dequeueProductCarrouselCell(
    withCarroulse component: YDSpaceyComponentCarrouselProduct,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: SpaceyProductCarrouselCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    
    guard let viewModel = viewModel else {
      return UICollectionViewCell()
    }
    
    getProductsIds(at: indexPath.item) { ids in
      if viewModel.carrouselProducts[indexPath.item] == nil {
        let carrouselContainer = YDSpaceyProductCarrouselContainer(
          id: indexPath.row,
          items: [],
          ids: [],
          pageNumber: -1,
          currentRectList: nil
        )
        viewModel.carrouselProducts[indexPath.item] = carrouselContainer
      }

      let productsIds = ids.inBatches(ofSize: viewModel.productsBatchesSize)
      viewModel.carrouselProducts[indexPath.item]?.ids = productsIds

      cell.indexPath = indexPath.item
      cell.isProductCarouselCouponEnabled = self.isProductCarouselCouponEnabled
      cell.config(
        with: indexPath.item,
        headerTitle: component.showcaseTitle,
        viewModel: viewModel,
        hasLivePulsing: !(component.showcaseTitle?.isEmpty ?? true)
      )
    }
    
    return cell
  }
}
