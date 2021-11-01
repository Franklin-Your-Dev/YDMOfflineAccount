//
//  YDQueue.swift
//  YDUtilities
//
//  Created by Douglas Hennrich on 26/10/21.
//

import Foundation

public struct YDQueue<T> {
  private var elements: [T] = []
  
  public init() {}

  public mutating func enqueue(_ value: [T]) {
    elements.append(contentsOf: value)
  }

  @discardableResult public mutating func dequeue() -> [T]? {
    guard !elements.isEmpty else {
      return nil
    }
    
    defer {
      elements.removeAll()
    }
    
    return elements
  }
}
