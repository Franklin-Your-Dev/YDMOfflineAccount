//
//  ProductDetailsViewModel.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 26/03/21.
//

import Foundation
import CoreLocation

import YDUtilities
import YDExtensions
import YDB2WIntegration
import YDB2WModels
import YDB2WServices
import YDB2WDeepLinks

protocol ProductDetailsViewModelDelegate: AnyObject {
  var error: Binder<Bool> { get }
  var loading: Binder<Bool> { get }
  var currentStore: Binder<YDStore?> { get }
  var currentProductOnlineOffline: Binder<YDProductOnlineOffline?> { get }

  func changeAddress()
  func openOnlineProduct()
  func getProductFromService()
}

typealias YDProductDetailsService = YDB2WServiceProductsDelegate &
  YDB2WServiceStoresDelegate

class ProductDetailsViewModel {
  // MARK: Properties
  let service: YDProductDetailsService = YDB2WService()
  var order: YDOfflineOrdersOrder
  var error: Binder<Bool> = Binder(false)
  var loading: Binder<Bool> = Binder(false)
  var currentStore: Binder<YDStore?> = Binder(nil)
  var currentProductOnlineOffline: Binder<YDProductOnlineOffline?> = Binder(nil)

  // MARK: Init
  init(product: YDProductOnlineOffline?, order: YDOfflineOrdersOrder) {
    self.order = order
    currentProductOnlineOffline.value = product

    let address = YDAddress(
      postalCode: order.addressZipcode,
      address: order.addressStreet,
      city: order.addressCity,
      state: order.addressState
    )

    currentStore.value = YDStore(
      id: order.storeId,
      name: order.formattedStoreName,
      address: address
    )
    
    self.trackEvent(.offlineOrdersProductDetails, ofType: .state)
  }
}

// MARK: Actions
extension ProductDetailsViewModel {
  private func trackEvent(
    _ name: TrackEvents,
    ofType type: TrackType,
    withParameters params: [String: Any]? = nil
  ) {
    YDIntegrationHelper.shared
      .trackEvent(
        withName: name,
        ofType: type,
        withParameters: params
      )
  }
  
  func getNewStoreAndProducts(with location: CLLocationCoordinate2D) {
    let parameters = TrackEvents.offlineOrdersProductDetails.parameters(
      body: ["action": "trocar loja"]
    )
    trackEvent(.offlineOrdersProductDetails, ofType: .action, withParameters: parameters)
    
    DispatchQueue.global(qos: .utility).async { [weak self] in
      guard let self = self else { return }
      self.loading.value = true

      let queueGroup = DispatchGroup()
      queueGroup.enter()

      self.searchForNewStore(with: location) { [weak self] store in
        guard let self = self else { return }

        if let store = store {
          self.currentStore.value = store
        }
        queueGroup.leave()
      }

      queueGroup.wait()
      self.getNewProducts()
    }
  }

  func searchForNewStore(
    with location: CLLocationCoordinate2D,
    onCompletion completion: @escaping (YDStore?) -> Void
  ) {
    service
      .getNearstLasa(with: location) { (response: Result<YDStores, YDB2WServices.YDServiceError>) in
        switch response {
          case .success(let stores):
            let sorted = stores.stores.prefix(10).compactMap { $0 }.sorted {
              $0.distance ?? 100000 < $1.distance ?? 100000
            }

            completion(sorted.first)

          case .failure(let error):
            print(#function, error.message)
            completion(nil)
        }
    }
  }
}

// MARK: Delegate
extension ProductDetailsViewModel: ProductDetailsViewModelDelegate {
  func changeAddress() {
    YDIntegrationHelper.shared.onAddressModule { [weak self] address in
      guard let self = self,
            let address = address,
            let coords = address.coords
      else { return }

      self.getNewStoreAndProducts(with: coords)
    }
  }

  func openOnlineProduct() {
    guard let product = currentProductOnlineOffline.value?.online,
          let productId = product.id
    else {
      return
    }

    let formatedString = String(
      format: YDDeepLinks.productClick.rawValue,
      productId
    )
    
    let parameters = TrackEvents.offlineOrdersProductDetails
      .parameters(body: ["action": "comprar produto online"])
    trackEvent(.offlineOrdersProductDetails, ofType: .action, withParameters: parameters)

    guard let url = URL(string: formatedString),
          !url.absoluteString.isEmpty else {
      return
    }

    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
  
  func getProductFromService() {
    let ean = currentProductOnlineOffline.value?.ean ?? ""
    let storeId = order.storeId
    
    loading.value = true
    
    service.getProductsFromRESQL(
      eans: [ean],
      storeId: storeId
    ) { [weak self] (response: Result<YDProductsRESQL, YDB2WServices.YDServiceError>) in
      guard let self = self else { return }

      switch response {
        case .success(let restql):
          self.onGetProductsFromRestQLSuccess(restql)

        case .failure(let error):
          self.loading.value = false
          self.error.value = true
          print(#function, error.message)
      }
    }
  }
}
