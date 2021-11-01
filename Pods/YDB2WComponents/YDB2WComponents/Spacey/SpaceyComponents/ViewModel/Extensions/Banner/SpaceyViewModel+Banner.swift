//
//  SpaceyViewModel+Banner.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 03/10/21.
//

import UIKit

// MARK: Product Delegate
public protocol YDSpaceyViewModelBannerDelegate: AnyObject {
  func openBanner(with url: String?)
}

extension YDSpaceyViewModel {
  public func onOpenBanner(with url: String?) {
    bannerDelegate?.openBanner(with: url)
  }
}
