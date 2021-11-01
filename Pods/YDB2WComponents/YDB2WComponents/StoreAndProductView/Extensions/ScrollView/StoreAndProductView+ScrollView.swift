//
//  StoreAndProductView+ScrollView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 26/03/21.
//

import UIKit

extension YDStoreAndProductView: UITextViewDelegate {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrolledPageDown(scrollView) {
      delegate?.didMove(direction: .up)
      return
    }
    delegate?.didMove(direction: .down)
  }

  public func scrolledPageDown(_ scrollView: UIScrollView) -> Bool {
    return scrollView.panGestureRecognizer.translation(in: scrollView).y < 0
  }
}
