//
//  YDProductCardView+UIState.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 08/04/21.
//

import UIKit

import YDUtilities

extension YDProductCardView: YDUIStateDelegate {
  public func changeUIState(with type: YDUIStateEnum) {
    if type == .normal {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }

        self.container.isHidden = false
        self.shimmerContainer.isHidden = true

        self.shimmers.forEach { $0.stopShimmer() }
      }
      //
    } else if type == .loading {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }

        self.container.isHidden = true
        self.shimmerContainer.isHidden = false

        self.shimmers.forEach { $0.startShimmer() }
      }
    }
  }
}
