//
//  YDStoreAndProductView+UIState.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 07/04/21.
//

import UIKit

import YDUtilities

extension YDStoreAndProductView: YDUIStateDelegate {
  public func changeUIState(with type: YDUIStateEnum) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }

      switch type {
        case .normal:
          self.emptyView.isHidden = true
          self.errorView.isHidden = true
          self.textView.isHidden = false
          self.shimmerTextView.isHidden = true
          self.shimmerTextView.subviews.forEach { $0.stopShimmer() }
          self.storeNameAndAddressView.changeUIState(with: .normal)
          self.productCardView.isHidden = false
          self.productCardView.changeUIState(with: .normal)
          self.updateLayoutWithProduct()

        case .loading:
          self.emptyView.isHidden = true
          self.errorView.isHidden = true
          self.textView.isHidden = true
          self.textView.text = ""
          self.tableView.contentOffset = .zero
          self.shimmerTextView.isHidden = false
          self.shimmerTextView.subviews.forEach { $0.startShimmer() }
          self.storeNameAndAddressView.changeUIState(with: .loading)
          self.productCardView.isHidden = false
          self.productCardView.changeUIState(with: .loading)
          self.segmentedControl.selectedSegmentIndex = 0
          self.segmentedControl.setEnabled(false, forSegmentAt: 0)
          self.segmentedControl.setEnabled(false, forSegmentAt: 1)

        case .empty:
          self.emptyView.isHidden = false
          self.errorView.isHidden = true
          self.textView.isHidden = true
          self.textView.text = ""
          self.tableView.contentOffset = .zero
          self.shimmerTextView.isHidden = true
          self.shimmerTextView.subviews.forEach { $0.stopShimmer() }
          self.productCardView.isHidden = true

        case .error:
          self.errorView.isHidden = false
          self.emptyView.isHidden = true
          self.textView.isHidden = true
          self.textView.text = ""
          self.tableView.contentOffset = .zero
          self.shimmerTextView.isHidden = true
          self.shimmerTextView.subviews.forEach { $0.stopShimmer() }
          self.productCardView.isHidden = true

        default:
          break
      }
    }
  }
}
