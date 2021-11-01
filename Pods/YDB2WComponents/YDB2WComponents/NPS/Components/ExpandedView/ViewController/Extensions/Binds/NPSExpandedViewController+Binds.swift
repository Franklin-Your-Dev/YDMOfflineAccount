//
//  NPSExpandedViewController+Binds.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 20/10/21.
//

import UIKit

extension YDNPSExpandedViewController {
  func configureBinds() {
    spaceyViewModel?.loading.bind { isLoading in
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        
        if isLoading {
          self.spaceyViewController?.view.isHidden = true
          self.shimmerView.isHidden = false
          self.shimmerView.startShimmers()
        } else {
          self.spaceyViewController?.view.isHidden = false
          self.shimmerView.isHidden = true
          self.shimmerView.stopShimmers()
        }
      }
    }
  }
}
