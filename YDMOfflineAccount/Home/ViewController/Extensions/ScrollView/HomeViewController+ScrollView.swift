//
//  HomeViewController+ScrollView.swift
//  YDMstoreModeOfflineAccount
//
//  Created by Douglas Hennrich on 14/01/21.
//

import UIKit

extension HomeViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
      // reach bottom
      toggleNavShadow(true)
    }

    if (scrollView.contentOffset.y < 0){
      //reach top
      toggleNavShadow(false)
      Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
        self?.navBarShadowOff = true
      }
    }

    if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
      // not top and not bottom
      if navBarShadowOff {
        navBarShadowOff = false
        toggleNavShadow(true)
      }
    }
  }
}
