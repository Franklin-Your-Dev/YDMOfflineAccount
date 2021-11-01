//
//  YDBrand.swift
//  YDB2WBrandManager
//
//  Created by Douglas Hennrich on 04/10/21.
//

import Foundation

public class YDBrand: Decodable {
  // MARK: Properties
  public let type: YDBrandType
  public var strings: YDBrandStrings
  
  // MARK: Computed Variables
  public var name: String {
    switch type {
      case .ACOM:
        return "Americanas"
        
      case .SUBA:
        return "Submarino"
    }
  }
  
  public var codeName: String {
    switch type {
      case .ACOM:
        return "acom"
        
      case .SUBA:
        return "suba"
    }
  }
  
  public var urlName: String {
    switch type {
      case .ACOM:
        return "americanas"
        
      case .SUBA:
        return "submarino"
    }
  }
  
  // MARK: Coding Keys
  enum CodingKeys: String, CodingKey {
    case type = "brandCodename"
    case strings
  }
  
  // MARK: Init
  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.type = try container.decode(YDBrandType.self, forKey: .type)
    
    if let strings = try? container.decode(YDBrandStrings.self, forKey: .strings) {
      self.strings = strings
    } else {
      self.strings = YDBrandStrings()
    }
  }
  
  public init(brandName: YDBrandType = .ACOM) {
    self.type = brandName
    self.strings = YDBrandStrings()
  }
}

// MARK: Brand Type
public enum YDBrandType: String, Decodable {
  case ACOM = "Americanas"
  case SUBA = "Submarino"
}

// MARK: Brand Strings
public class YDBrandStrings: Decodable {
  // MARK: Properties
  public var shopCart: String? = "cesta"
  
  public var defaultErrorTitle: String? = "Ooops"
  public var defaultErrorMessage: String? = "ooops, tivemos um problema"
  
  // MARK: CodingKeys
  enum CodingKeys: String, CodingKey {
    case shopCart
    case defaultErrorTitle = "errorTitle"
    case defaultErrorMessage = "errorMessage"
  }
  
  // MARK: Init
  init() {}
}
