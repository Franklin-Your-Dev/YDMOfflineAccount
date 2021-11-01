//
//  NPSViewController+Binds.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 19/10/21.
//

import Foundation

extension NPSViewController {
  func configureBinds() {
    viewModel?.isSendButtonEnabled.bind { [weak self] enabled in
      guard let self = self else { return }
      
      self.npsView?.setSendButtonEnabled(enabled)
    }
  }
}
