//
//  SpaceyViewController+Binds.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 16/04/21.
//

import UIKit

public extension YDSpaceyViewController {
  func configureBinds() {
    viewModel?.loading.bind { [weak self] isLoading in
      guard let self = self else { return }

      if isLoading {
        self.shimmerTableView.isHidden = false
        self.collectionView.isHidden = true
      }
    }

    viewModel?.componentsList.bindOnce { [weak self] list in
      guard let self = self else { return }

      self.collectionView.reloadData()

      let time: Double = Double(list.count)
      
      // Logic to deal with layout break
      Timer.scheduledTimer(
        withTimeInterval: 0.4 * time,
        repeats: false
      ) { _ in
        DispatchQueue.main.async {
          self.shimmerTableView.isHidden = true
          self.collectionView.isHidden = false
          self.collectionView.collectionViewLayout.invalidateLayout()
          self.delegate?.onComponentsList(list)
          self.viewModel?.loading.value = false
        }
      }
    }

    viewModel?.playerComponent.bind { [weak self] player in
      guard let self = self,
            let player = player
      else { return }

      self.delegate?.onPlayerComponentID(player.videoId)
    }
  }
}
