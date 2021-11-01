//
//  YDIntegration+GetView.swift
//  YDB2WIntegration
//
//  Created by Douglas Hennrich on 25/08/21.
//

import UIKit

public extension YDIntegrationHelper {
  func getReactHotsiteView(
    from path: String,
    onCompletion completion: @escaping (_ view: UIView?) -> Void
  ) {
    presentationDelegate?.getReactHotsiteView(from: path, onCompletion: completion)
  }
}
