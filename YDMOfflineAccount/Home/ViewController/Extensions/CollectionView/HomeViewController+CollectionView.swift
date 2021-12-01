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
    return viewModel?.listItensOffiline.count ?? 0
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: HomeViewCell.identifier,
      for: indexPath
    ) as! HomeViewCell
    
    if let item = viewModel?.listItensOffiline[indexPath.row] {
      cell.populateView(item: item)
    }
    
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
    
    if let user = viewModel?.currentUser {
      header.populateView(user: user)
    }
    
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
    if let item = viewModel?.listItensOffiline[indexPath.row].type {
      viewModel?.onCard(tag: item)
    }
  }

}
