//
//  NPSExpandedUIDelegate.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 18/10/21.
//

import UIKit

public protocol YDNPSExpandedUIDelegate: AnyObject {
  func updateNavBarTitle(_ title: String?)
  func scrollViewDidScroll(_ scrollView: UIScrollView)
  func snackBarSuccessText(_ text: String?)
}
