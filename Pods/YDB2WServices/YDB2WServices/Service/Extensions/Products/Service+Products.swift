//
//  Service+Products.swift
//  YDB2WServices
//
//  Created by Douglas Hennrich on 15/07/21.
//

import Foundation
import YDB2WModels
import Alamofire
import YDUtilities
import YDB2WIntegration

public protocol YDB2WServiceProductsDelegate {
  func getProductsFromRESQL(
    eans: [String],
    storeId: String?,
    onCompletion completion: @escaping (Swift.Result<YDProductsRESQL, YDServiceError>) -> Void
  )

  func getProduct(
    ofIds ids: (id: String, sellerId: String),
    onCompletion completion: @escaping (Swift.Result<YDProductFromIdInterface, YDServiceError>) -> Void
  )
  
  func getProductsLasaOffer(
    userId: String,
    onCompletion completion: @escaping (Swift.Result<YDProductLasaOffersInterface, YDServiceError>) -> Void
  )
}

extension YDB2WService {
  public func getProductsFromRESQL(
    eans: [String],
    storeId: String?,
    onCompletion completion: @escaping (Swift.Result<YDProductsRESQL, YDServiceError>) -> Void
  ) {
    var parameters: [String: String] = [:]

    if let storeId = storeId {
      parameters["store"] = storeId
    }
    
    let context = YDIntegrationHelper.shared.getNavigationContextParameters()
    parameters = parameters.merging(context) { (_, new) in new }

    DispatchQueue.global().async { [weak self] in
      guard let self = self else { return }

      var url = "\(self.restQL)/run-query/app/lasa-and-b2w-product-by-ean/\(self.restQLVersion)?"

      eans.forEach { url += "ean=\($0)&" }

      self.service.requestWithFullResponse(
        withUrl: String(url.dropLast()),
        withMethod: .get,
        withHeaders: nil,
        andParameters: parameters
      ) { response in
        guard let data = response.data else {
          completion(
            .failure(.init(withMessage: "Nenhum dado retornado"))
          )
          return
        }

        do {
          guard let json = try JSONSerialization.jsonObject(
            with: data,
            options: .allowFragments
          ) as? [String: Any] else {
            completion(
              .failure(.init(withMessage: "Nenhum dado retornado"))
            )
            return
          }

          let restQL = YDProductsRESQL(withJson: json)
          completion(.success(restQL))

        } catch {
          completion(
            .failure(
              .init(error: error)
            )
          )
        }
      }
    }
  }

  public func getProduct(
    ofIds ids: (id: String, sellerId: String),
    onCompletion completion: @escaping (Swift.Result<YDProductFromIdInterface, YDServiceError>) -> Void
  ) {
    var parameters = [
      "productIds": ids.id,
      "sellerId": ids.sellerId
    ]
    
    let context = YDIntegrationHelper.shared.getNavigationContextParameters()
    parameters = parameters.merging(context) { (_, new) in new }

    let url = "\(products)/product_cells_by_ids"

    DispatchQueue.global().async { [weak self] in
      guard let self = self else { return }
      self.service.requestWithoutCache(
        withUrl: url,
        withMethod: .get,
        andParameters: parameters
      ) { (result: Swift.Result<[Throwable<YDProductFromIdInterface>], YDServiceError>) in
        switch result {
        case .success(let products):
          if let product = products.compactMap({ try? $0.result.get() }).first {
            completion(.success(product))
          } else {
            completion(.failure(.notFound))
          }

        case .failure(let error):
          completion(.failure(error))
        }
      }
    }
  }
  
  public func getProductsLasaOffer(
    userId: String,
    onCompletion completion: @escaping (Swift.Result<YDProductLasaOffersInterface, YDServiceError>) -> Void
  ) {
    var parameters: [String: String] = [
      "customerId": userId
    ]
    
    let context = YDIntegrationHelper.shared.getNavigationContextParameters()
    parameters = parameters.merging(context) { (_, new) in new }
    
    let url = "\(products)/lasa-offer"
    
    DispatchQueue.global().async { [weak self] in
      guard let self = self else { return }
      
      self.service.requestWithoutCache(
        withUrl: url,
        withMethod: .get,
        andParameters: parameters,
        onCompletion: completion
      )
    }
  }
}
