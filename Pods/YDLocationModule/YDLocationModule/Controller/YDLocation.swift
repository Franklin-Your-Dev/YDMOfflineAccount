//
//  YDLocation.swift
//  YDLocationModule
//
//  Created by Douglas Hennrich on 14/09/20.
//  Copyright © 2020 YourDev. All rights reserved.
//

import UIKit
import CoreLocation

public class YDLocation: NSObject {

  // MARK: Properties
  public static let shared = YDLocation()

  public weak var delegate: YDLocationDelegate? {
    didSet {
      canTrigger = true
    }
  }

  private var canTrigger = false

  private var status: CLAuthorizationStatus = {
    return CLLocationManager.authorizationStatus()
  }()

  private let locationManager = CLLocationManager()

  // MARK: Init
  public override init() {
    super.init()
    locationManager.delegate = self
  }

  // MARK: Actions
  private func requestAuthorization() {
    DispatchQueue.global().async { [weak self] in
      DispatchQueue.main.async { [weak self] in
        self?.locationManager.requestWhenInUseAuthorization()
      }
    }
  }

  private func searchForCurrentLocation() {
    DispatchQueue.global().async { [weak self] in
      DispatchQueue.main.async { [weak self] in
        self?.locationManager.requestLocation()
      }
    }
  }

  private func deniedPermission() {
    DispatchQueue.global().async { [weak self] in
      DispatchQueue.main.async { [weak self] in
        self?.delegate?.permissionDenied()
      }
    }
  }

  private func locationError(error: Error) {
    DispatchQueue.global().async { [weak self] in
      DispatchQueue.main.async { [weak self] in
        self?.delegate?.locationError(error)
      }
    }
  }
}

// MARK: Public Actions
extension YDLocation {

  public func getStatus() -> CLAuthorizationStatus {
    return status
  }

  public func start() {
    if status == .notDetermined {
      requestAuthorization()
      return
    }

    if status == .denied {
      deniedPermission()
      return
    }

    searchForCurrentLocation()
  }
}

extension YDLocation: CLLocationManagerDelegate {

  public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    self.status = status

    if !canTrigger {
      return
    }
    
    delegate?.onStatusChange(status)

    if status == .authorizedWhenInUse {
      searchForCurrentLocation()

    } else if status == .denied {
      deniedPermission()
    }
  }

  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let currentLocation = locations.last {
      DispatchQueue.global().async { [weak self] in
        DispatchQueue.main.async { [weak self] in
          self?.delegate?.onLocation(currentLocation)
        }
      }
    }
  }

  public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    locationError(error: error)
  }
}
