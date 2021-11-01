//
//  YDProductLasaOfferDiscount.swift
//  YDB2WModels
//
//  Created by Douglas Hennrich on 30/08/21.
//

import Foundation

public class YDProductLasaOfferDiscount: Codable {
  public let productId: String
  public let image: String?
  public let title: String?
  public let price: Double?
  public let percent: String?
  public let units: String?
  public var offerActivationStatus: String?
  public var discountActivated: Bool {
    guard let status = offerActivationStatus,
          status == "ACTIVATED"
    else {
      return false
    }

    return true
  }

  // MARK: Computed variables
  public var formattedPrice: String? {
    return price?.formatedPrice
  }

  // MARK: Init
  public init(
    productId: String,
    image: String? = nil,
    title: String? = nil,
    price: Double? = nil,
    percent: String? = nil,
    units: String? = nil,
    offerActivationStatus: String? = nil
  ) {
    self.productId = productId
    self.image = image
    self.title = title
    self.price = price
    self.percent = percent
    self.units = units
    self.offerActivationStatus = offerActivationStatus
  }
}

// MARK: Conforms to equatable
extension YDProductLasaOfferDiscount: Equatable {
  public static func == (
    lhs: YDProductLasaOfferDiscount,
    rhs: YDProductLasaOfferDiscount
  ) -> Bool {
    return lhs.productId == rhs.productId
  }
}
