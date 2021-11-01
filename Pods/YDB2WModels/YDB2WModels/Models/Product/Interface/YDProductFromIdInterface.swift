//
//  YDProductFromIdInterface.swift
//  YDB2WModels
//
//  Created by Douglas Hennrich on 23/05/21.
//

import Foundation

public class YDProductFromIdInterface: Decodable {
  public var partnerId: String?
  public var productId: String
  public var name: String
  public var description: String
  public var images: [String]?
  public var rating: Double?
  public var numReviews: Int?
  public var price: String?
  public var priceConditions: String?
  public var priceFrom: String?
  public var ean: String?
  public var stock: String?
  public var couponName: String?
  public var couponDeeplink: String?
  public var discountBadgeText: String?

  enum CodingKeys: String, CodingKey {
    case partnerId
    case productId = "prodId"
    case name
    case description
    case images
    case rating
    case numReviews
    case price
    case priceConditions = "installment"
    case priceFrom
    case ean = "productSku"
    case stock
    case couponName = "coupon"
    case couponDeeplink
    case discountBadgeText
  }
}
