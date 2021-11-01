//
//  SpaceyBannerCarrouselCollectionViewCell+Delegate.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 03/10/21.
//

import UIKit

extension SpaceyBannerCarrouselCollectionViewCell: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    guard let banner = getBannerComponent(at: indexPath) else { return }
    
    viewModel?.onOpenBanner(with: banner.deepLink)
  }
}
