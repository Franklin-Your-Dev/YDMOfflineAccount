//
//  ConfigKeysEnum.swift
//  YDIntegration
//
//  Created by Douglas Hennrich on 27/10/20.
//  Copyright © 2020 YourDev. All rights reserved.
//

import Foundation

public enum YDConfigKeys: String {
  case store = "ydevO2O"
  case live = "ydevLive"
  
  case brand = "ydevBrand"

  case restQL = "restQLService"
  case chatService = "userChatService"
  case chatWebSocketService = "userChatWebSocketService"
  case productService = "catalog_service"
  case storeService = "store_service"
  case spaceyService = "spacey_service"
  case addressService = "zip_code_service"
  case lasaClientService = "lasaCustomerPortal"
  case invoiceService = "offlineOrdersNoteService"
  case googleService = "youtubeStatisticsApi"
  case neowayService = "neowayService"
  case customerSupportService = "customer_support_service"
}
