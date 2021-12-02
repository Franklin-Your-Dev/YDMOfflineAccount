//
//  TermsViewModel.swift
//  YDMstoreModeOfflineAccount
//
//  Created by Douglas Hennrich on 02/02/21.
//

import Foundation

import YDB2WIntegration
import YDUtilities
import YDExtensions
import YDB2WModels

// MARK: Navigation
protocol TermsNavigationDelegate {
  func onBack()
}

// MARK: Delegate
protocol TermsViewModelDelegate {
  var loading: Binder<Bool> { get }
  var customView: Binder<UIView?> { get }

  func getCustomView()
  func onBack()
}

// MARK: ViewModel
class TermsViewModel {
  // MARK: Properties
  let navigation: TermsNavigationDelegate
  var loading = Binder(false)
  var customView: Binder<UIView?> = Binder(nil)
  
  let customViewPath: String

  // MARK: Init
  init(navigation: TermsNavigationDelegate, customViewPath: String) {
    self.navigation = navigation
    self.customViewPath = customViewPath
    
    YDIntegrationHelper.shared.trackEvent(withName: .offlineAccountTerms, ofType: .state)
  }
}

// MARK: Extension Delegate
extension TermsViewModel: TermsViewModelDelegate {
  func getCustomView() {
    YDIntegrationHelper.shared.getReactHotsiteView(from: customViewPath) { [weak self] view in
      guard let self = self else { return }
      guard let view = view else {
        self.onBack()
        return
      }
      
      self.customView.value = view
    }
  }

  func onBack() {
    navigation.onBack()
  }
}
