//
//  YDMFindStoreViewModel+Location.swift
//  YDMFindStore
//
//  Created by Douglas Hennrich on 08/12/20.
//

import Foundation
import CoreLocation

import YDB2WIntegration
import YDLocationModule
import YDB2WModels
import YDB2WServices

extension YDMFindStoreViewModel {
  func callAddressModuleFromB2W() {
    integration.onAddressModule { [weak self] addressComponentOpt in
      guard let self = self else { return }
      guard let addressComponent = addressComponentOpt,
            let coordinates = addressComponent.coords
      else {
        self.location.fire()
        return
      }

      let address = addressComponent.formatAddress
      let type = addressComponent.type

      self.searchForNewStore(
        with: coordinates,
        givingAddress: address,
        givingType: type
      )
    }
  }

  func searchForNewStore(
    with location: CLLocationCoordinate2D,
    givingAddress address: String? = nil,
    givingType type: YDAddressType? = .unknown
  ) {
    loading.value = true

    latestLocation = location
    latestAddress = address
    latestType = type

    service.getNearstLasa(
      with: location
    ) { [weak self] (response: Result<YDStores, YDServiceError>) in
      guard let self = self else { return }
      self.loading.value = false

      switch response {
        case .success(let list):
          var currentAddress = address

          if currentAddress == nil,
             let storeAddress = list.stores.first?.formatAddress {
            currentAddress = storeAddress
          }

          self.location.value = YDLocationViewModel(
            address: currentAddress ?? "",
            location: location,
            store: list.stores.first
          )

          self.stores.value = list.stores

        case .failure(let error):
          self.location.fire()
          self.error.fire()
          self.logger.error(error.localizedDescription)
      }
    }
  }
}

// MARK: YDLocation delegate
extension YDMFindStoreViewModel: YDLocationDelegate {

  func onStatusChange(_ status: CLAuthorizationStatus) {
    //
    print("[YDLocation] status changed")
  }

  public func permissionDenied() {
    print(#function)
    location.fire()
  }

  public func locationError(_ error: Error) {
    print(#function, error.localizedDescription)
    location.fire()
  }

  public func onLocation(_ location: CLLocation) {
    service.getAddressFromLocation(
      location.coordinate
    ) { [weak self] (response: Result<[YDAddress], YDServiceError>) in
      guard let self = self else { return }

      switch response {
        case .success(let addresses):
          guard let address = addresses.first else {
            self.logger.error(YDServiceError.notFound.message)
            self.location.fire()
            return
          }

          self.searchForNewStore(
            with: location.coordinate,
            givingAddress: address.formatAddress,
            givingType: .location
          )

          self.integration.setNewAddress(
            withCoords: location.coordinate,
            withAddress: address.formatAddress,
            withType: .location
          )

        case .failure(let error):
          self.logger.error(error.message)
          self.location.fire()
      }
    }
  }
}
