//
//  Animations.swift
//  YDB2WAssets
//
//  Created by Douglas Hennrich on 02/08/21.
//

import Foundation
import YDB2WBrandManager
import YDB2WModels

private let podsBundle = Bundle(for: YDAssets.self)

private func getBrandType() -> YDBrandType {
  YDBrandManager.shared.brand?.type ?? .ACOM
}

private enum FilesMap {
  static let live: String = {
    getBrandType() == .ACOM ? "ACOM_live" : "SUBA_live"
  }()
}

public enum YDAnimations {
  public static var live = podsBundle.path(forResource: FilesMap.live, ofType: "json")
}
