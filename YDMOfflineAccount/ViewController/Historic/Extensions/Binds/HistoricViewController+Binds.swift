//
//  HistoricViewController+Binds.swift
//  YDMstoreModeOfflineAccount
//
//  Created by Douglas Hennrich on 08/02/21.
//

import UIKit

extension HistoricViewController {
  func setBinds() {
    viewModel?.loading.bind { isLoading in
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }

        if isLoading {
          self.scrollView.isHidden = true
          self.separatorView.isHidden = true
          self.exportButton.isHidden = true
          self.activityIndicator.isHidden = false
          self.activityIndicator.startAnimating()
        } else {
          self.scrollView.isHidden = false
          self.separatorView.isHidden = false
          self.exportButton.isHidden = false
          self.activityIndicator.isHidden = true
        }
      }
    }

    viewModel?.historicList.bind { [weak self] _ in
      self?.buildList()
    }

    viewModel?.error.bind { _ in
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.separatorView.isHidden = true
        self.errorView.isHidden = false
      }
    }
  }
}
