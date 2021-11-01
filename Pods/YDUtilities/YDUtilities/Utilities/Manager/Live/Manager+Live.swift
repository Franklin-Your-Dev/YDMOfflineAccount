//
//  Manager+Live.swift
//  YDUtilities
//
//  Created by Douglas Hennrich on 10/09/21.
//

import Foundation

public extension YDManager {
  class Lives {
    // MARK: Properties
    public static let shared = YDManager.Lives()
    
    public var sessionInitialized = false
    public var liveIsOpened = false
    
    // MARK: Init
    private init() {}
  }
}
