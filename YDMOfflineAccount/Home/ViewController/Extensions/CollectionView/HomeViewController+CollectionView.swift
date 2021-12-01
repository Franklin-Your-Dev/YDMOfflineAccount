//
//  HomeViewController+CollectionView.swift
//  YDMOfflineAccount
//
//  Created by magna on 27/11/21.
//

import UIKit

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return listItensOffiline.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: HomeViewCell.identifier,
      for: indexPath
    ) as! HomeViewCell
    
    cell.populateView(item: (listItensOffiline[indexPath.row]))
    
    return cell
  }
  

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    
    let header = collectionView.dequeueReusableSupplementaryView(
      ofKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: HomeHeaderViewCell.identifier,
      for: indexPath
    ) as! HomeHeaderViewCell
    
    header.populateView(user: viewModel!.currentUser)
    
    return header
    
  }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: view.frame.size.width, height: 150)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
      
    return CGSize(width: view.frame.size.width, height: 170)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel?.onCard(tag: listItensOffiline[indexPath.row].type)
  }

}
