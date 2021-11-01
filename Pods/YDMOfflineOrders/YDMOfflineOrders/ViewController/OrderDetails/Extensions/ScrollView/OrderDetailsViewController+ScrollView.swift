//
//  OrderDetailsViewController+ScrollView.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 14/03/21.
//

import UIKit

extension OrderDetailsViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let contentOffset = scrollView.contentOffset.y
    let contentMinusSize = scrollView.contentSize.height - scrollView.frame.size.height

    if contentOffset >= contentMinusSize {
      // reach bottom
      toggleNavShadow(true)
    }

    if contentOffset <= 0 {
      //reach top
      toggleNavShadow(false)

      Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
        self?.navBarShadowOff = true
      }
    }

    if contentOffset >= 0 && contentOffset < contentMinusSize {
      // not top and not bottom
      if navBarShadowOff {
        navBarShadowOff = false
        toggleNavShadow(true)
      }
    }
  }
}
