//
//  YDMFindStoreViewModel.swift
//  YDMFindStore
//
//  Created by Douglas Hennrich on 27/11/20.
//

import UIKit
import CoreLocation

import YDB2WIntegration
import YDUtilities
import YDExtensions
import YDB2WModels
import YDLocationModule
import YDB2WServices
import YDB2WDeepLinks

// MARK: Navigation
protocol YDMFindStoreNavigationDelegate {
  func onExit()
}

// MARK: Delegate
protocol YDMFindStoreViewModelDelegate {
  var error: Binder<Bool> { get }
  var loading: Binder<Bool> { get }
  var location: Binder<YDLocationViewModel?> { get }
  var stores: Binder<[YDStore]> { get }

  func trackMetric()
  func getPreviousAddress()
  subscript(_ index: Int) -> YDStore? { get }

  func onExit()
  func onGetLocation()
  func onGetCurrentLocation()
  func onStoreCardAction(type: OnStoreCardActionEnum, store: YDStore)
  func refreshRequest()
  func openListMetric()
  func annotationMetric()
  func productMetric()
}

// MARK: View Model
class YDMFindStoreViewModel {
  // MARK: Properties
  lazy var logger = Logger.forClass(Self.self)
  let navigation: YDMFindStoreNavigationDelegate
  let service: YDB2WServiceDelegate
  let integration = YDIntegrationHelper.shared

  var error: Binder<Bool> = Binder(false)
  var loading: Binder<Bool> = Binder(false)
  var location: Binder<YDLocationViewModel?> = Binder(nil)
  var stores: Binder<[YDStore]> = Binder([])

  var latestLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(
    latitude: 0,
    longitude: 0
  )
  var latestAddress: String?
  var latestType: YDAddressType? = .unknown

  private let locationManager = YDLocation.shared
  private var alreadyGetUsersPosition = false

  // MARK: Init
  init(
    navigation: YDMFindStoreNavigationDelegate,
    service: YDB2WServiceDelegate = YDB2WService()
  ) {
    self.navigation = navigation
    self.service = service
  }
}

// MARK: Extension delegate
extension YDMFindStoreViewModel: YDMFindStoreViewModelDelegate {
  subscript(_ index: Int) -> YDStore? {
    return stores.value.at(index)
  }

  func trackMetric() {
    integration.trackEvent(withName: .findStore, ofType: .state)
  }

  func getPreviousAddress() {
    integration.getAddress { [weak self] currentAddress in
      guard let self = self else { return }
      guard let address = currentAddress,
            let coordinates = address.coords
      else {
        self.onGetLocation()
        return
      }

      self.searchForNewStore(
        with: coordinates,
        givingAddress: address.formatAddress,
        givingType: address.type
      )
    }
  }

  func onExit() {
    navigation.onExit()
  }

  func onGetLocation() {
    locationManager.delegate = nil
    locationManager.delegate = self

    guard location.value?.address != nil,
          alreadyGetUsersPosition
    else {
      locationManager.start()
      alreadyGetUsersPosition = true
      return
    }

    callAddressModuleFromB2W()
  }

  func onGetCurrentLocation() {
    locationManager.delegate = nil
    locationManager.delegate = self

    locationManager.start()
  }

  func onStoreCardAction(type: OnStoreCardActionEnum, store: YDStore) {
    switch type {
    case .product:
      let parameters: [String: String] = [
        "sellerId": store.sellerID ?? "",
        "storeId": store.sellerStoreID ?? ""
      ]

      guard let urlString = queryString(YDDeepLinks.lasaStore.rawValue, params: parameters),
            let url = URL(string: urlString),
            !url.absoluteString.isEmpty else {
        return
      }

      productMetric()
      UIApplication.shared.open(url, options: [:], completionHandler: nil)

    case .whatsapp: break
    }
  }

  func refreshRequest() {
    searchForNewStore(
      with: latestLocation,
      givingAddress: latestAddress,
      givingType: latestType
    )
  }
  
  func openListMetric() {
    let parameters = TrackEvents.findStore.parameters(body: ["action": "mapa lista"])
    integration.trackEvent(withName: .findStore, ofType: .action, withParameters: parameters)
  }

  func annotationMetric() {
    let parameters = TrackEvents.findStore.parameters(body: ["action": "mapa icone"])
    integration.trackEvent(withName: .findStore, ofType: .action, withParameters: parameters)
  }

  func productMetric() {
    let parameters = TrackEvents.findStore.parameters(body: ["action": "mapa card loja comprar"])
    integration.trackEvent(withName: .findStore, ofType: .action, withParameters: parameters)
  }
}
