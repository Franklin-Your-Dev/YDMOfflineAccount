//
//  TaxCouponViewController+CollectionDataSource.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 26/08/21.
//

import UIKit
import YDExtensions
import YDB2WColors

extension YDTaxCouponViewController {
  func configureCollectionViewDataSource() {
    let layout = UICollectionViewFlowLayout()
    layout.estimatedItemSize = CGSize(width: view.frame.size.width, height: 40)
    layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 6, right: 0)
    layout.minimumLineSpacing = 0
    
    collectionView.collectionViewLayout = layout
    collectionView.dataSource = self
    collectionView.delegate = self
    
    collectionView.register(YDTaxCouponViewCell.self)
  }
}

extension YDTaxCouponViewController: UICollectionViewDataSource {
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return viewModel?.products.count ?? 0
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let product = viewModel?.products.at(indexPath.item) else {
      fatalError("No product found")
    }
    let cell: YDTaxCouponViewCell = collectionView
      .dequeueReusableCell(forIndexPath: indexPath)
    
    cell.contentView.backgroundColor = indexPath.item % 2 == 0 ?
      YDColors.Gray.disabled :
      YDColors.Gray.opaque
    
    cell.configure(with: product)
    return cell
  }
}

extension YDTaxCouponViewController: UICollectionViewDelegateFlowLayout {
  // Item Size
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
    let referenceHeight: CGFloat = 48
    let referenceWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width
      - sectionInset.left
      - sectionInset.right
      - collectionView.contentInset.left
      - collectionView.contentInset.right
    return CGSize(width: referenceWidth, height: referenceHeight)
  }
}
