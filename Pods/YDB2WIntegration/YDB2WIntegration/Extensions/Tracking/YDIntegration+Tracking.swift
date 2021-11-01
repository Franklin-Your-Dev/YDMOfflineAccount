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

    if type == .action {
      trackAdobeAction(actionName: eventName, parameters: payload)
      trackGAEvent(actionName: eventName, parameters: payload)

      trackFacebookEvent(eventName: eventName, parameters: payload)
      trackFirebaseEvent(eventName: eventName, parameters: payload)
    } else if type == .state {
      trackAdobeState(stateName: eventName, parameters: payload)
      trackGAScreen(stateName: eventName, parameters: payload)
    }
  }
}

extension YDIntegrationHelper {
  // MARK: Actions
  func trackAdobeAction(actionName: String, parameters: [String: Any]?) {
    trackingDelegate?.trackAdobeAction(actionName: actionName, parameters: parameters)
  }

  func trackGAEvent(actionName: String, parameters: [String: Any]?) {
    trackingDelegate?.trackGAEvent(actionName: actionName, parameters: parameters)
  }

  // MARK: State
  func trackAdobeState(stateName: String, parameters: [String: Any]?) {
    trackingDelegate?.trackAdobeState(stateName: stateName, parameters: parameters)
  }

  func trackGAScreen(stateName: String, parameters: [String: Any]?) {
    trackingDelegate?.trackGAScreen(stateName: stateName, parameters: parameters)
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
