//
//  YDMOfflineOrdersViewController+Binds.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 10/03/21.
//

import UIKit

import YDUtilities
import YDB2WComponents

extension YDMOfflineOrdersViewController {
  func setUpBinds() {
    viewModel?.orderListFirstRequest.bindOnce { [weak self] _ in
      guard let self = self,
            let orderList = self.viewModel?.orderList.value
      else { return }

      if !orderList.isEmpty {
        DispatchQueue.main.async {
          self.collectionView.reloadData()
          Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
            self.canLoadMore = true
          }
        }
      } else {
        self.showFeedbackStateView(ofType: .empty)
      }
    }

    viewModel?.newOrdersForList.bind { [weak self] hasMore in
      guard let self = self else { return }

      if hasMore {
        self.addNewOrders()
      } else {
        if self.loadMoreShimmer?.componentHidden == false {
          self.loadMoreShimmer?.componentHidden = true
          self.loadMoreShimmer?.stopShimmerAndHide()
          self.collectionView.collectionViewLayout.invalidateLayout()
        }
      }
    }

    viewModel?.loading.bind { [weak self] isLoading in
      guard let self = self else { return }

      DispatchQueue.main.async {
        if isLoading {
          self.loadingShimmer = true
          self.collectionView.reloadData()
          self.feedbackStateView.isHidden = true
        } else {
          self.loadingShimmer = false
          self.collectionView.reloadData()
        }
      }
    }

    viewModel?.error.bind { [weak self] _ in
      guard let self = self else { return }
      self.showFeedbackStateView(ofType: .error)
    }

    viewModel?.loadMoreError.bind { [weak self] message in
      guard let self = self,
            let message = message
      else { return }

      let snackBar = YDSnackBarView(parent: self.view)
      snackBar.delegate = self
      snackBar.showMessage(message, ofType: .withButton(buttonName: "atualizar"))

      Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
        self.canLoadMore = true
      }
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
    
    viewModel?.ordersInvoices.bind { _ in
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.collectionView.reloadData()
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
    
    viewModel?.errorDialog.bind { [weak self] params in
      guard let self = self else { return }
      
      let dialog = YDDialogCoordinator()
      dialog.delegate = self
      dialog.payload = ["error": true]
      
      dialog.start(
        ofType: .simple,
        customTitle: params.title,
        customMessage: params.message,
        messageLink: [
          "message": "atendimento.acom@americanas.com",
          "link": "mailto:atendimento.acom@americanas.com"
        ]
      )
    }
  }
}
