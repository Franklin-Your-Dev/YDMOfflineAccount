//
//  YDMFindStoreViewController+Location.swift
//  YDMFindStore
//
//  Created by Douglas Hennrich on 08/12/20.
//

import UIKit
import CoreLocation

import YDB2WIntegration
import YDB2WAssets
import YDExtensions

extension YDMFindStoreViewController {
  func locationActivity(show: Bool = true) {
    if show {
      locationActivityIndicator.isHidden = false
      locationActivityIndicator.startAnimating()
      locationButton.setTitle("", for: .normal)
      locationButton.setImage(nil, for: .normal)
      locationPinIcon.isHidden = true
      locationChevronIcon.isHidden = true

      //
    } else {
      locationActivityIndicator.stopAnimating()
      locationPinIcon.isHidden = false
      locationChevronIcon.isHidden = false
      locationButton.setTitle(
        viewModel?.location.value?.address ?? "encontre uma americanas perto de você",
        for: .normal
      )
      locationButton.setImage(YDAssets.Icons.point, for: .normal)
    }
  }
}
