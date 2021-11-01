//
//  YDProductLasaOffer.swift
//  YDB2WModels
//
//  Created by Douglas Hennrich on 30/08/21.
//

import Foundation

public class YDProductLasaOffersInterface: Codable {
  public let categories: [YDProductLasaOfferCategory]
  
  enum CodingKeys: String, CodingKey {
    case categories = "aggregation"
  }
}

public class YDProductLasaOfferCategory: Codable {
  // MARK: Properties
  public let name: String
  public var products: [YDProductLasaOffer]
  
  // MARK: Init
  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    name = try container.decode(String.self, forKey: .name)

    let throwables = try container.decode(
      [Throwable<YDProductLasaOffer>].self,
      forKey: .products
    )
    
    products = []

    throwables.forEach {
      switch $0.result {
      case .success(let product):
        products.append(product)

      case .failure(let error as NSError):
        print(error.debugDescription)
      }
    }
  }

  // MARK: CodinKeys
  enum CodingKeys: CodingKey {
    case name
    case products
  }
}

public class YDProductLasaOffer: Codable {
  // MARK: Properties
  public let image: String?
  public let code: String?
  public let departmentId: Int?
  public let productBrand: String?
  public let productDescription: String?
  public let limitMessage: String?
  public let eans: [String]?
  public let priceFrom: Double?
  public let priceTo: Double?
  public let totalDiscount: String?
  public let startDate: String?
  public let endDate: String?
  public let offerActivationStatus: String?

  // MARK: CodingKeys
  enum CodingKeys: String, CodingKey {
    case image
    case code
    case endDate
    case departmentId
    case productBrand
    case productDescription = "description"
    case limitMessage
    case eans
    case priceFrom
    case priceTo
    case totalDiscount
    case startDate
    case offerActivationStatus
  }
}
