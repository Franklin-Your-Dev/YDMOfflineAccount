//
//  DeepLinkManager+OfflineOrders.swift
//  YDB2WDeepLinks
//
//  Created by Douglas Hennrich on 05/10/21.
//

import Foundation
import YDB2WIntegration

extension YDDeepLinkManager {
  func onOfflineOrders() {
    YDIntegrationHelper.shared.openOfflineOrders()
  }
}
