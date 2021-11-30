//
//  HomeViewController+Layout.swift
//  YDMOfflineAccount
//
//  Created by magna on 30/11/21.
//

import UIKit

extension HomeViewController {
  func setupCollectionView() {
    
    let layout  = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    collectionView!.register(
      HomeViewCell.self,
      forCellWithReuseIdentifier: HomeViewCell.identifier
    )
    
    collectionView!.register(
      HomeHeaderViewCell.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: HomeHeaderViewCell.identifier
    )
    
    collectionView!.delegate = self
    collectionView!.dataSource = self
    collectionView!.backgroundColor = .white
    
    self.view.addSubview(collectionView!)
    
    collectionView!.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      collectionView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      collectionView!.topAnchor.constraint(equalTo: self.view.topAnchor),
      collectionView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    ])
    
  }
}
