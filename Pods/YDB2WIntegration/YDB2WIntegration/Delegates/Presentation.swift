//
//  Presentation.swift
//  YDIntegration
//
//  Created by Douglas Hennrich on 27/10/20.
//  Copyright © 2020 YourDev. All rights reserved.
//

import UIKit

import YDB2WModels

public protocol YDIntegrationHelperPresentationDelegate {
  func presentScanner()
  func presentStoreMode(deeplink: String?)
  func presentLive(navigationController: UINavigationController?, deepLink: String?)
  func presentSelectAddress(completion: ((YDAddress?) -> Void)?)
  func presentOfflineOrders(navigationController: UINavigationController?)
  
  func getReactHotsiteView(
    from path: String,
    onCompletion completion: @escaping (_ view: UIView?) -> Void
  )
}
