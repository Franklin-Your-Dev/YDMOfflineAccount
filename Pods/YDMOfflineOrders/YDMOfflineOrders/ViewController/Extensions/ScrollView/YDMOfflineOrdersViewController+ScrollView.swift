//
//  YDMOfflineOrdersViewController+ScrollView.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 21/02/21.
//

import UIKit

extension YDMOfflineOrdersViewController: UIScrollViewDelegate {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // reach bottom
    if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
      toggleNavShadow(true)
    }

    // reach top
    if scrollView.contentOffset.y < 0 {
      toggleNavShadow(false)
      Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
        self?.navBarShadowOff = true
      }
    }

    // not top and not bottom
    if scrollView.contentOffset.y >= 0 &&
          scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height) {
      if navBarShadowOff {
        navBarShadowOff = false
        toggleNavShadow(true)
      }
    }
  }
}
