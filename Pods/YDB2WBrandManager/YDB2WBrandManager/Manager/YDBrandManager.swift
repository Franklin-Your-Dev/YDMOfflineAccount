//
//  YDBrandManager.swift
//  YDB2WBrandManager
//
//  Created by Douglas Hennrich on 01/09/21.
//

import Foundation

public class YDBrandManager: Decodable {
  // MARK: Properties
  public static let shared = YDBrandManager()
  public var brand: YDBrand?
  
  // MARK: Init
  private init() {}
}

// MARK: Public actions
public extension YDBrandManager {
  func buildBrand(with config: Data) {
    guard let brand = try? JSONDecoder().decode(YDBrand.self, from: config)
    else {
      fatalError("Não foi possível dar decode na brand")
    }
    
    self.brand = brand
  }
  
  func buildBrand(with json: [String: Any]) {
    guard let brandName = json["brandName"] as? String,
          let brandType = YDBrandType(rawValue: brandName)
          else {
      self.brand = YDBrand(brandName: .ACOM)
      return
    }
    
    self.brand = YDBrand(brandName: brandType)
  }
  
  func buildBrand(with brand: YDBrand) {
    self.brand = brand
  }
}
