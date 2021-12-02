//
//  TermsViewController+Binds.swift
//  YDMstoreModeOfflineAccount
//
//  Created by Douglas Hennrich on 04/06/21.
//

import UIKit
import YDExtensions

extension TermsViewController {
  func configureBinds() {
    viewModel?.loading.bind { [weak self] isLoading in
      guard let self = self else { return }
      isLoading ? self.view.startLoader() : self.view.stopLoader()
    }

    viewModel?.customView.bind { [weak self] customView in
      guard let self = self else { return }
      guard let customView = customView else { return }
      
      self.attachCustomView(customView)
    }
  }
}
