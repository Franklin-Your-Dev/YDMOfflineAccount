//
//  YDMStoreModeOfflineAccountViewModel.swift
//  YDMstoreModeOfflineAccount
//
//  Created by Douglas on 12/01/21.
//

import UIKit

import YDB2WIntegration
import YDUtilities
import YDExtensions
import YDB2WModels
import YDB2WComponents

// MARK: Navigation
protocol HomeViewModelNavigationDelegate {
  func onBack()
  func onExit()
  func openUserData()
  func openCustomerIdentifier()
  func openOfflineOrders()
}

// MARK: Delegate
protocol HomeViewModelDelegate {
  var currentUser: YDCurrentCustomer { get }
  var error: Binder<(title: String, message: String)> { get }
  var customerIdentifierEnabled: Bool { get set }
  var emailDialog: Binder<Bool> { get }
  
  func onExit()
  func trackState()
  func onCard(tag: ItensOffilineAccountEnum)
}

// MARK: ViewModel
class HomeViewModel {
  // MARK: Properties
  let navigation: HomeViewModelNavigationDelegate
  var currentUser: YDCurrentCustomer
  var error: Binder<(title: String, message: String)> = Binder(("", ""))
  var customerIdentifierEnabled = true
  var emailDialog = Binder(false)
  
  var userClientLasaToken: String = ""

  // MARK: Init
  init(
    navigation: HomeViewModelNavigationDelegate,
    user: YDCurrentCustomer
  ) {
    self.navigation = navigation
    self.currentUser = user
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

// MARK: Extension Delegate
extension HomeViewModel: HomeViewModelDelegate {
  func onExit() {
    navigation.onExit()
  }

  func trackState() {
    YDIntegrationHelper.shared.trackEvent(withName: .offlineAccountPerfil, ofType: .state)
  }

  func onCard(tag: ItensOffilineAccountEnum) {
    switch tag {
      case .customerIdentifier:
        // QR Card
        navigation.openCustomerIdentifier()
        
      case .store:
        // User Data
        let parameters = TrackEvents.offlineAccountPerfil.parameters(body: ["action": "meus dados"])
        
        YDIntegrationHelper.shared
          .trackEvent(
            withName: .offlineAccountPerfil,
            ofType: .action,
            withParameters: parameters
          )
        
        navigation.openUserData()

      case .clipboard:
        // Offline orders
        let parameters = TrackEvents.offlineAccountPerfil.parameters(body: ["action": "minhas compras"])
        
        YDIntegrationHelper.shared
          .trackEvent(
            withName: .offlineAccountPerfil,
            ofType: .action,
            withParameters: parameters
          )
        
        addQuizObservers()
        navigation.openOfflineOrders()
    }
  }
}
