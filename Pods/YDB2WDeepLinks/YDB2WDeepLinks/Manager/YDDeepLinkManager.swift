//
//  YDDeepLinkManager.swift
//  YDB2WDeepLinks
//
//  Created by Douglas Hennrich on 30/09/21.
//

import Foundation

public class YDDeepLinkManager {
  // MARK: Properties
  public static let shared = YDDeepLinkManager()
  
  // MARK: Init
  private init() {}
  
  // MARK: Actions
  public func parse(url: URL) {
    let (path: pathOpt, parameters: parametersOpt) = YDDeepLinksParser.parse(url: url)
    guard let path = pathOpt else { return }
    
    determineWhatToGo(with: path, parameters: parametersOpt, url: url)
  }
}

// MARK: Private Actions
extension YDDeepLinkManager {
  private func determineWhatToGo(with path: YDDeepLinksParserTypes, parameters: [String : Any]?, url: URL) {
    switch path {
      case .nps: break
        
      case .liveNeedHelp:
        onLiveNeedHelp()
        
      case .offlineOrders:
        onOfflineOrders()
    }
  }
}
