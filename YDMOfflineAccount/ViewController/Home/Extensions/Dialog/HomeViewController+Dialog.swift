//
//  YDMStoreModeOfflineAccountViewController+Dialog.swift
//  YDMstoreModeOfflineAccount
//
//  Created by Douglas Hennrich on 15/01/21.
//

import UIKit

import YDB2WComponents

extension HomeViewController {
  func showAlert(title: String, message: String) {
    YDDialog().start(
      ofType: .simple,
      customTitle: title,
      customMessage: message
    )
  }
}
