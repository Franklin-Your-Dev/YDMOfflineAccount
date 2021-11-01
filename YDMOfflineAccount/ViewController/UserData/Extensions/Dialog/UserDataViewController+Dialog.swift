//
//  UserDataViewController+Dialog.swift
//  YDMstoreModeOfflineAccount
//
//  Created by Douglas Hennrich on 29/01/21.
//

import Foundation

import YDB2WComponents

extension UserDataViewController {
  func showAlert(title: String, message: String) {
    let dialog = YDDialog()
    dialog.delegate = self
    dialog.start(
      ofType: .simple,
      customTitle: title,
      customMessage: message,
      messageLink: [
        "message": "atendimento.acom@americanas.com",
        "link": "mailto:atendimento.acom@americanas.com"
      ]
    )
  }
}

extension UserDataViewController: YDDialogCoordinatorDelegate {
  func onActionYDDialog(payload: [String: Any]?) {
    viewModel?.onBack()
  }

  func onCancelYDDialog(payload: [String: Any]?) {
    viewModel?.onBack()
  }
}
