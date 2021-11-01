//
//  SpaceyViewController+Title.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 13/05/21.
//

import UIKit

import YDB2WModels

extension YDSpaceyViewController {
  func dequeueTitleCell(
    withTitle title: YDSpaceyComponentTitle,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: SpaceyTitleCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    cell.configure(withTitle: title.contentTitle)
    return cell
  }
}
