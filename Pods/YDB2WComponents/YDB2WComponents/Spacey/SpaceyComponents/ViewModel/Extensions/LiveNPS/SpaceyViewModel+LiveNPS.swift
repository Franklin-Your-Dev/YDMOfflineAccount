//
//  SpaceyViewModel+LiveNPS.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 08/10/21.
//

import Foundation
import YDB2WModels

public protocol YDSpaceyViewModelLiveNPSDelegate: AnyObject {
  func sendLiveNPS(with nps: YDSpaceyComponentLiveNPSCard, spaceyId: String)
}

public extension YDSpaceyViewModel {
  func sendLiveNPS(with nps: YDSpaceyComponentLiveNPSCard?) {
    guard let nps = nps else { return }
    
    liveNPSDelegate?.sendLiveNPS(with: nps, spaceyId: self.spaceyId)
  }
}
