//
//  YDDialogViewModel.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 17/11/20.
//

import Foundation

// MARK: Delegate
public protocol YDDialogNavigationDelegate: AnyObject {
  func onAction()
  func onCancelAction()
  func onLinkAction(_ link: String?)
}

protocol YDDialogViewModelDelegate: AnyObject {
  func onButtonAction()
  func onCancelAction()
  func onLinkAction(_ link: String?)
}

// MARK: ViewModel
class YDDialogViewModel {
  // MARK: Properties
  let navigation: YDDialogNavigationDelegate

  // MARK: Init
  init(navigation: YDDialogNavigationDelegate) {
    self.navigation = navigation
  }
}

extension YDDialogViewModel: YDDialogViewModelDelegate {
  func onButtonAction() {
    navigation.onAction()
  }

  func onCancelAction() {
    navigation.onCancelAction()
  }
  
  func onLinkAction(_ link: String?) {
    navigation.onLinkAction(link)
  }
}
