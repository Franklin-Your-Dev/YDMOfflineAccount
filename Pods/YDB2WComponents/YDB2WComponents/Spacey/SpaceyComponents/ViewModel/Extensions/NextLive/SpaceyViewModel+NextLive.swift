//
//  SpaceyViewModel+NextLive.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 17/08/21.
//

import Foundation
import YDB2WModels

// MARK: NextLive Delegate
public protocol YDSpaceyViewModelNextLiveDelegate: AnyObject {
  func openNextLives()
  func saveNextLiveOnCalendar(
    live: YDSpaceyComponentNextLive,
    onCompletion completion: @escaping (_ success: Bool) -> Void
  )
}

public extension YDSpaceyViewModel {
  func openNextLives() {
    nextLiveDelegate?.openNextLives()
  }
  
  func saveNextLiveOnCalendar(
    live: YDSpaceyComponentNextLive,
    onCompletion completion: @escaping (_ success: Bool) -> Void
  ) {
    nextLiveDelegate?.saveNextLiveOnCalendar(live: live, onCompletion: completion)
  }
}
