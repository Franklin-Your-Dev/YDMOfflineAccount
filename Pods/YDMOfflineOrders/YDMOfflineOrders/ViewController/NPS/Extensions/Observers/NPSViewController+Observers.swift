//
//  NPSViewController+Observers.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 20/10/21.
//

import UIKit

extension NPSViewController {
  func configureObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShowOrHide),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShowOrHide),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }
  
  @objc func keyboardWillShowOrHide(_ notification: Notification) {
    guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
    else { return }

    let keyboardScreenEndFrame = keyboardValue.cgRectValue
    let keyboardHeight = (keyboardScreenEndFrame.height + 20) - (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0)

    if notification.name == UIResponder.keyboardWillHideNotification {
      npsViewBottomConstraint?.constant = 0
    } else if notification.name == UIResponder.keyboardWillShowNotification {
      npsViewBottomConstraint?.constant = -keyboardHeight
    }

    view.layoutIfNeeded()
  }
}
