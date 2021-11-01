//
//  StoreAndProductView+SegmentedControl.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 26/03/21.
//

import UIKit

// MARK: Segmented Control Delegate
extension YDStoreAndProductView: YDSegmentedControlDelegate {
  public func onChangeYDSegmentControl(_ value: Int, segmented: UISegmentedControl) {
    changeSegmentControl(value)
  }
}

extension YDStoreAndProductView {
  func changeSegmentControl(_ value: Int) {
    tableView.isHidden = value == 0
    textView.isHidden = value != 0

    delegate?.didMove(direction: value == 0 ? .down : .up)
  }
}
