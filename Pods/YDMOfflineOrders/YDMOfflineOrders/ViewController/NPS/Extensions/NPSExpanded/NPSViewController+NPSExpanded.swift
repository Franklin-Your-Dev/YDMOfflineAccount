//
//  NPSViewController+NPSExpanded.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 19/10/21.
//

import Foundation
import YDB2WComponents

// MARK: UI Delegate
extension NPSViewController: YDNPSExpandedUIDelegate {
  func updateNavBarTitle(_ title: String?) {
    self.title = title
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
      // reach bottom
      UIView.animate(withDuration: 0.5) { [weak self] in
        guard let self = self else { return }
        self.shadowView.layer.applyShadow(x: 0, y: 2, blur: 4)
      }
    }
    
    if (scrollView.contentOffset.y < 0){
      // reach top
      UIView.animate(withDuration: 0.5) { [weak self] in
        guard let self = self else { return }
        self.shadowView.layer.shadowOpacity = 0
        
      }
    }
    
    if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
      // not top and not bottom
      UIView.animate(withDuration: 0.5) { [weak self] in
        guard let self = self else { return }
        
        self.shadowView.layer.applyShadow(x: 0, y: 2, blur: 4)
      }
    }
  }
  
  func snackBarSuccessText(_ text: String?) {
    viewModel?.snackBarSuccessMessage = text
  }
}

// MARK: Action Delegate
extension NPSViewController: YDNPSExpandedActionDelegate {
  func onNPSSendButtonAction() {
    viewModel?.onSendButtonAction()
  }
}
