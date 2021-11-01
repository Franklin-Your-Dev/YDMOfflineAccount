//
//  OrderDetailsViewController+Binds.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 06/04/21.
//

import UIKit

import YDB2WComponents

extension OrderDetailsViewController {
  func setUpBinds() {
    viewModel?.order.bind { [weak self] _ in
      guard let self = self else { return }
      self.collectionView.reloadData()
    }

    viewModel?.snackBar.bind { [weak self] params in
      guard let self = self else { return }

      let snack = YDSnackBarView(parent: self.view)

      if let buttonTitle = params.button {
        snack.showMessage(params.message, ofType: .withButton(buttonName: buttonTitle))
      } else {
        snack.showMessage(params.message, ofType: .simple)
      }
    }
    
    viewModel?.invoiceDialog.bind { [weak self] url in
      guard let self = self else { return }
      guard let url = url else { return }

      let dialog = YDDialog()
      dialog.delegate = self
      dialog.payload = ["nfe": url]
      dialog.start(
        ofType: .withCancel,
        customTitle: "atenção",
        customMessage: "acesse e confira através do site da nota fiscal eletrônica.",
        customButton: "ver nota fiscal",
        customCancelButton: "depois vejo"
      )
    }
    
    viewModel?.showNPSViewWithRemainingDays.bind { remainingDays in
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        guard let days = remainingDays else {
          self.NPSView.heightConstraint.constant = 0
          self.NPSView.isHidden = true
          self.NPSViewSeparatorView.isHidden = true
          return
        }
        
        self.NPSView.heightConstraint.constant = 60
        self.NPSView.isHidden = false
        self.NPSView.configure(remainingDays: days)
        self.NPSViewSeparatorView.isHidden = false
      }
    }
  }
}
