//
//  SpaceyViewController+Banner.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 13/05/21.
//

import UIKit

import YDB2WModels

extension YDSpaceyViewController {
  func dequeueBannerCell(
    withBanner banner: YDSpaceyComponentBanner,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: SpaceyBannerCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

    cell.config(with: banner)
    return cell
  }
}
