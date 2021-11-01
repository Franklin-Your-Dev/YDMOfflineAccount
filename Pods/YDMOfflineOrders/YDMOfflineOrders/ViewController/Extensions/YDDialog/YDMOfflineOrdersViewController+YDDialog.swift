//
//  YDMOfflineOrdersViewController+YDDialog.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 14/03/21.
//

import UIKit

import YDB2WComponents
import YDB2WIntegration

extension YDMOfflineOrdersViewController: YDDialogCoordinatorDelegate {
  public func onActionYDDialog(payload: [String: Any]?) {
    guard let nfe = payload?["nfe"] as? URL else {
      if payload?["error"] != nil {
        navigationController?.popViewController(animated: true)
      }
      return
    }

    YDIntegrationHelper.shared
      .trackEvent(
        withName: .offlineOrders,
        ofType: .action,
        withParameters: [
          "&ea=": "clique-botao",
          "&el=": "Botão ver nota fiscal"
        ]
      )

    UIApplication.shared.open(nfe)
  }

  public func onCancelYDDialog(payload: [String: Any]?) {}
}
