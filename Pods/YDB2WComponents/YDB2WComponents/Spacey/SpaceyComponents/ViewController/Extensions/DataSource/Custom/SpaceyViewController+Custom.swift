//
//  SpaceyViewController+Custom.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 10/06/21.
//
import UIKit
import YDB2WModels

extension YDSpaceyViewController {
  func dequeueCustomCell(
    with component: YDSpaceyCustomComponentDelegate,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    return delegate?
      .dequeueCustomCell(
        collectionView,
        forIndexPath: indexPath,
        component: component
      ) ?? UICollectionViewCell()
  }
}
