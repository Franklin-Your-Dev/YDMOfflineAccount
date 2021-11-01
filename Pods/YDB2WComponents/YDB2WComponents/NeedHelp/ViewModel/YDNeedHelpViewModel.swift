//
//  YDNeedHelpViewModel.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 29/09/21.
//

import Foundation

protocol YDNeedHelpViewModelNavigation {
  func onExit()
  func openForm()
}

protocol YDNeedHelpViewModelDelegate: AnyObject {
  func onExit()
  func openForm()
}

class YDNeedHelpViewModel {
  // MARK: Properties
  let navigation: YDNeedHelpViewModelNavigation
  
  // MARK: Init
  init(navigation: YDNeedHelpViewModelNavigation) {
    self.navigation = navigation
  }
}

extension YDNeedHelpViewModel: YDNeedHelpViewModelDelegate {
  func onExit() {
    navigation.onExit()
  }
  
  func openForm() {
    navigation.openForm()
  }
}
