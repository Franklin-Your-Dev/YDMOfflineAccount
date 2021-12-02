//
//  HomeViewController+Binds.swift
//  YDMstoreModeOfflineAccount
//
//  Created by Douglas Hennrich on 15/01/21.
//

import UIKit

extension HomeViewController {
  func setBinds() {
    viewModel?.error.bind { [weak self] params in
      self?.showAlert(title: params.title, message: params.message)
    }
    
    viewModel?.listItensOffiline.bind { _ in
      DispatchQueue.main.async { [weak self] in
        self?.collectionView?.reloadData()
      }
    }
    
  }
}
