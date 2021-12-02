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
import YDB2WAssets

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
  var listItensOffiline: Binder<[ItensOffinlineAccount]> { get }
  var error: Binder<(title: String, message: String)> { get }
  var customerIdentifierEnabled: Bool { get set }
  var flagNewCustomerIdentifierEnable: Bool { get set }
  var emailDialog: Binder<Bool> { get }
  
  func onExit()
  func buildList()
  func trackState()
  func onCard(tag: ItensOffilineAccountEnum)
}

// MARK: ViewModel
class HomeViewModel {
  // MARK: Properties
  let navigation: HomeViewModelNavigationDelegate
  var currentUser: YDCurrentCustomer
  var error: Binder<(title: String, message: String)> = Binder(("", ""))
  var customerIdentifierEnabled = false
  var flagNewCustomerIdentifierEnable = false

  var customerIdentifierEnabled = true
  var emailDialog = Binder(false)
  
  var userClientLasaToken: String = ""
  
  var listItensOffiline: Binder<[ItensOffinlineAccount]> = Binder([ItensOffinlineAccount(
    icon: YDAssets.Images.store!,
    title: "suas compras nas lojas físicas",
    type: .store,
    new: false
  ),
  ItensOffinlineAccount(
    icon: YDAssets.Images.clipboard!,
    title: "seu histórico de dados informados nas lojas",
    type: .clipboard,
    new: false
  )])

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
  
  func buildList() {
    
    if customerIdentifierEnabled {
      let customerIdentifier = ItensOffinlineAccount(
        icon: YDAssets.Images.qrCodeCard!,
        title: "identifique-se aqui e facilite suas compras nas lojas físicas :)",
        type: .customerIdentifier,
        new: flagNewCustomerIdentifierEnable
      )
      listItensOffiline.value.insert(customerIdentifier, at: 0)
    }
    
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

      case .clipboard:
        // User Data
        let parameters = TrackEvents.offlineAccountPerfil.parameters(body: ["action": "meus dados"])
        
        YDIntegrationHelper.shared
          .trackEvent(
            withName: .offlineAccountPerfil,
            ofType: .action,
            withParameters: parameters
          )
        
        navigation.openUserData()
    }
  }
}