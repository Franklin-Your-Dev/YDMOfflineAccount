//
//  YDSpaceyHelper.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 07/06/21.
//

import UIKit
import YDExtensions
import YDB2WModels

enum YDSpaceyHelper {
  static func registerCells(
    in collectionView: UICollectionView,
    for type: YDSpaceyComponentsTypes.Types? = nil
  ) {
    if case .grid = type {
      collectionView.register(SpaceyBannerCollectionViewCell.self)
      collectionView.register(SpaceyTitleCollectionViewCell.self)
      collectionView.register(SpaceyGridCollectionViewCell.self)
      collectionView.register(SpaceyProductCarrouselCollectionViewCell.self)
      
    } else {
      collectionView.register(SpaceyBannerCollectionViewCell.self)
      collectionView.register(SpaceyTitleCollectionViewCell.self)
      collectionView.register(SpaceyStarCollectionViewCell.self)
      collectionView.register(SpaceyOptionsListCollectionViewCell.self)
      collectionView.register(SpaceyBannerCarrouselCollectionViewCell.self)
      collectionView.register(SpaceyGridCollectionViewCell.self)
      collectionView.register(SpaceyGradeListCollectionViewCell.self)
      collectionView.register(SpaceyCardViewCell.self)
      collectionView.register(SpaceyMultipleChoicesListCollectionViewCell.self)
      collectionView.register(SpaceyEditTextCollectionViewCell.self)
      collectionView.register(SpaceyTermsOfUseCollectionViewCell.self)
      collectionView.register(SpaceyNextLiveCollectionViewCell.self)
      collectionView.register(SpaceyNextLiveWithTitleAndButtonCollectionViewCell.self)
      collectionView.register(SpaceyProductCarrouselCollectionViewCell.self)
    }
  }
  
  static func configureCollectionLayout(
    numberOfColumns columns: Int = 1,
    inside view: UIView
  ) -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    let width: CGFloat = (view.frame.size.width / CGFloat(columns)).rounded(.up)
    
    if columns > 1 {
      layout.itemSize = CGSize(width: width, height: width)
    } else {
      layout.estimatedItemSize = CGSize(width: view.frame.width, height: 50)
    }
    
    layout.minimumLineSpacing = 16
    // layout.minimumInteritemSpacing = 16
    
    return layout
  }
}
