//
//  OrderDetailsViewModel+Observers.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 20/10/21.
//

import Foundation
import YDUtilities
import YDB2WIntegration

extension OrderDetailsViewModel {
  func configureObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(snackBarNotification),
      name: YDConstants.Notification.NPSSent,
      object: nil
    )
  }
  
  @objc func snackBarNotification(_ notification: Notification) {
    let message = notification.userInfo?["message"] as? String ??
      "Resposta enviada! Obrigada por participar :)"
    
    snackBar.value = (message: message, button: nil)
    showNPSViewWithRemainingDays.value = nil
    
    guard let orderId = order.value.cupom else { return }
    YDManager.OfflineOrders.shared.replyNPSOrder(withId: "\(orderId)")
  }
}
