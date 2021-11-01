//
//  YDDeepLinksParser.swift
//  YDB2WDeepLinks
//
//  Created by Douglas Hennrich on 21/05/21.
//

import Foundation
import YDExtensions

public enum YDDeepLinksParser {
  // MARK: Actions
  public static func parse(url: URL) -> (
    path: YDDeepLinksParserTypes?,
    parameters: [String: Any]?
  ) {
    let allComponents = url.host.map { [$0] + url.pathComponents } ?? url.pathComponents
    let components = allComponents
      .filter { $0 != "/" }
      .map { $0.removingPercentEncoding ?? "" }

    var params: [String: String] = [:]

    if let parameters = url.queryParameters {
      for (key, value) in parameters {
        params[key] = value
      }
    }

    return (
      path: YDDeepLinksParserTypes(rawValue: components.last ?? ""),
      parameters: params
    )
  }
}

public enum YDDeepLinksParserTypes: String {
  case nps
  case liveNeedHelp = "enviarAjuda"
  case offlineOrders = "minhascompras"
}

public enum YDDeepLinksParserParameters: String {
  case storeId = "storeId"
  case forceOpen
}
