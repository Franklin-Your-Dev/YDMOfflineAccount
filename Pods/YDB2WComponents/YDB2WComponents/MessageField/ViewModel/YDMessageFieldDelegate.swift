//
//  YDMessageFieldViewModel.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 22/10/20.
//

import Foundation

// MARK: Delegate
public protocol YDMessageFieldDelegate: AnyObject {
  func sendMessage(_ message: String)
  func onLike()
  func onError(_ message: String, status: Int)
}
