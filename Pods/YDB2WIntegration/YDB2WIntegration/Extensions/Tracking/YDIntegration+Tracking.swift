//
//  YDIntegration+Tracking.swift
//  YDB2WIntegration
//
//  Created by Douglas Hennrich on 08/12/20.
//

import Foundation

// MARK: Tracking
public extension YDIntegrationHelper {
  func trackEvent(
    withName name: TrackEvents,
    ofType type: TrackType,
    withParameters parameters: [String: Any]? = nil
  ) {
    var payload: [String: Any] = [:]

    payload = payload.merging(name.defaultParameters) { _, new in new }

    if let parameters = parameters {
      payload = payload.merging(parameters) { (_, new) in new }
    }

    // FOR TESTING
//    Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
//      UIAlertController.showAlert(title: "Evento: \(name.rawValue)", message: "tipo: \(type.rawValue)\npayload: \(payload)")
//    }
    
    let eventName = name.eventName
    let pageType = payload["pageType"] as? String
    let action = payload["ea"] as? String
    let category = payload["ec"] as? String
    let label = payload["el"] as? String

    if type == .action {
      trackGAEvent(
        eventName: eventName,
        pageType: pageType,
        action: action,
        category: category,
        label: label,
        customData: payload
      )

      trackFacebookEvent(eventName: eventName, parameters: payload)
      trackFirebaseEvent(eventName: eventName, parameters: payload)
    } else if type == .state {
      trackGAScreen(
        eventName: eventName,
        pageType: pageType,
        customData: payload
      )
    }
  }
}

extension YDIntegrationHelper {
  // MARK: Actions
  func trackGAEvent(
    eventName: String,
    pageType: String?,
    action: String?,
    category: String?,
    label: String?,
    customData: [String: Any]? = [:]
  ) {
    trackingDelegate?.trackGAEvent(
      action: action,
      category: category,
      eventLabel: label,
      eventName: eventName,
      pageType: pageType,
      customData: customData
    )
  }

  // MARK: State
  func trackGAScreen(eventName: String, pageType: String?, customData: [String : Any]? = [:]) {
    trackingDelegate?.trackGAScreen(eventName: eventName, pageType: pageType, customData: customData)
  }

  // MARK: Event
  func trackFacebookEvent(eventName: String, parameters: [String: Any]?) {
    trackingDelegate?.trackFacebookEvent(eventName: eventName, parameters: parameters)
  }

  func trackFirebaseEvent(eventName: String, parameters: [String: Any]?) {
    trackingDelegate?.trackFirebaseEvent(eventName: eventName, parameters: parameters)
  }
  
  // MARK: Exposed
  public func trackNewRelicEvent(eventName: String, parameters: [String: Any]?) {
    trackingDelegate?.trackNewRelicEvent(eventName: eventName, parameters: parameters)
  }

  public func trackStuartEvent(
    namespace: TrackEventsNameSpace,
    event: TrackEvents,
    parameters: [String: Any]?
  ) {
    trackingDelegate?.trackStuartEvent(
      namespace: namespace.rawValue,
      eventName: event.eventName,
      parameters: parameters
    )
  }
}
