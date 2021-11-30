//
//  TrackingDelegate.swift
//  YDIntegration
//
//  Created by Douglas Hennrich on 27/10/20.
//  Copyright © 2020 YourDev. All rights reserved.
//

import Foundation

public protocol YDIntegrationHelperTrackingDelegate {
  func trackGAEvent(
    action: String?,
    category: String?,
    eventLabel: String?,
    eventName: String?,
    pageType: String?,
    customData: [String: Any]?
  )

  func trackGAScreen(
    eventName: String?,
    pageType: String?,
    customData: [String: Any]?
  )

  func trackFacebookEvent(eventName: String, parameters: [String: Any]?)
  func trackFirebaseEvent(eventName: String, parameters: [String: Any]?)
  func trackNewRelicEvent(eventName: String, parameters: [String: Any]?)
  func trackStuartEvent(namespace: String, eventName: String, parameters: [String: Any]?)
}
