//
//  ProductDetailsViewModel+Products.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 08/09/21.
//

import Foundation
import YDB2WModels
import YDB2WServices

extension ProductDetailsViewModel {
  func getNewProducts() {
    guard let storeId = currentStore.value?.sellerStoreID,
          let ean = currentProductOnlineOffline.value?.ean
    else {
      loading.value = false
      return
    }

    service.getProductsFromRESQL(
      eans: [ean],
      storeId: storeId
    ) { [weak self] (response: Result<YDProductsRESQL, YDB2WServices.YDServiceError>) in
      guard let self = self else { return }
      self.loading.value = false

      switch response {
        case .success(let result):
          self.onGetProductsFromRestQLSuccess(result)

        case .failure(let error):
          print(#function, error.message)
          self.error.fire()
      }
    }
  }
  
  func onGetProductsFromRestQLSuccess(_ interface: YDProductsRESQL) {
    guard let firstProduct = interface.products.first else {
      self.loading.value = false
      return
    }
    
    if firstProduct.online?.ean == nil {
      firstProduct.online?.ean = currentProductOnlineOffline.value?.ean
      firstProduct.offline?.ean = currentProductOnlineOffline.value?.ean
    }

    currentProductOnlineOffline.value = firstProduct
    self.loading.value = false
  }
}
