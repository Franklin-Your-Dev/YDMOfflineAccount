//
//  PreHomeViewModel.swift
//  YDMstoreModeOfflineAccount
//
//  Created by Douglas Hennrich on 17/02/21.
//

import UIKit

protocol PreHomeNavigationDelegate {
  func assignInternalNavigationController(_ nav: UINavigationController?)
}

protocol PreHomeViewModelDelegate {
  func assignInternalNavigationController(_ nav: UINavigationController?)
}

class PreHomeViewModel {
  let navigation: PreHomeNavigationDelegate

  init(navigation: PreHomeNavigationDelegate) {
    self.navigation = navigation
  }
}

extension PreHomeViewModel: PreHomeViewModelDelegate {
  func assignInternalNavigationController(_ nav: UINavigationController?) {
    navigation.assignInternalNavigationController(nav)
  }
}
