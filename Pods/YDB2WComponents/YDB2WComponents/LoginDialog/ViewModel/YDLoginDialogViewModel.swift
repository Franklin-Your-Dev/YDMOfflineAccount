//
//  YDLoginDialogViewModel.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 05/11/20.
//

import Foundation

// MARK: Delegate
protocol YDLoginDialogViewModelDelegate: AnyObject {
  func onExit()
  func onLogin()
}

protocol YDLoginDialogNavigationDelegate: AnyObject {
  func onExit()
  func onLogin()
}

//
class YDLoginDialogViewModel {
  // MARK: Properties
  let navigation: YDLoginDialogNavigationDelegate

  // MARK: Init
  init(navigation: YDLoginDialogNavigationDelegate) {
    self.navigation = navigation
  }
}

// MARK: Extension
extension YDLoginDialogViewModel: YDLoginDialogViewModelDelegate {
  func onExit() {
    navigation.onExit()
  }

  func onLogin() {
    navigation.onLogin()
  }
}
