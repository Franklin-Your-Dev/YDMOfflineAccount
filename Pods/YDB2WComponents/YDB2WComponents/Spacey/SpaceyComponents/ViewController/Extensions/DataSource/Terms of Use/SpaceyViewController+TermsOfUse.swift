//
//  SpaceyViewController+TermsOfUse.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 04/06/21.
//

import UIKit

import YDB2WModels

extension YDSpaceyViewController {
  func dequeueTermsOfUseCell(
    with component: YDSpaceyComponentTermsOfUse,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: SpaceyTermsOfUseCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    cell.configure(with: component)
    return cell
  }
}
