//
//  YDSpaceyViewController+Grid.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 25/05/21.
//

import UIKit
import YDB2WModels

extension YDSpaceyViewController {
  func dequeueGridCell(
    with component: YDSpaceyComponentGrid,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: SpaceyGridCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

    cell.configure(with: component)
    return cell
  }
}
