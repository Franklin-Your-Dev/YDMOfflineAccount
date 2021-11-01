//
//  SpaceyBannerCarrouselCollectionViewCell+DataSource.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 13/05/21.
//

import UIKit

import YDExtensions
import YDB2WModels

extension SpaceyBannerCarrouselCollectionViewCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let carrousel = viewModel?.componentsList
            .value.at(carrouselId)?.component
    else {
      return 0
    }

    return carrousel.children.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: SpaceyBannerOnCarrouselCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    
    guard let banner = getBannerComponent(at: indexPath)
    else {
      return UICollectionViewCell()
    }

    cell.configure(with: banner)
    return cell
  }
}
