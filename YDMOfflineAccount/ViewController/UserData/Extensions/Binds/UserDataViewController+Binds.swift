//
//  UserDataViewController+Binds.swift
//  YDMstoreModeOfflineAccount
//
//  Created by Douglas Hennrich on 25/01/21.
//

import Foundation

import YDB2WComponents
import YDB2WModels

extension UserDataViewController {
  func setBinds() {
    viewModel?.error.bind { [weak self] params in
      self?.showAlert(title: params.title, message: params.message)
    }

    viewModel?.errorView.bind { _ in
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.separatorView.isHidden = true
        self.errorView.isHidden = false
      }
    }

    viewModel?.snackBarMessage.bind { [weak self] message in
      guard let self = self,
        let message = message else { return }

      let snack = YDSnackBarView(parent: self.view)
      snack.showMessage(message, ofType: .simple)
    }

    viewModel?.loading.bind { isLoading in
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }

        if isLoading {
          self.tableView.isHidden = true
          self.separatorView.isHidden = true
          self.activityIndicator.isHidden = false
          self.activityIndicator.startAnimating()
        } else {
          self.tableView.isHidden = false
          self.separatorView.isHidden = false
          self.activityIndicator.isHidden = true
        }
      }
    }

    viewModel?.usersInfo.bind { [weak self] _ in
      guard let self = self else { return }
      self.tableView.reloadData()

      if let dateString = self.viewModel?.userData?.date,
         let formated = YDLasaClientDataSet.formatDate(dateString) {
        self.lastUpdateLabelTitle.isHidden = false
        self.lastUpdateLabel.isHidden = false
        self.lastUpdateLabel.text = formated
      }

      self.historicButton.isHidden = false
      self.separatorView.isHidden = false
    }
  }
}
