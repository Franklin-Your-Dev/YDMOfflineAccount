//
//  YDMStoreModeOfflineAccountCoordinator.swift
//  YDMstoreModeOfflineAccount
//
//  Created by Douglas on 12/01/21.
//

import UIKit
import Hero

import YDB2WIntegration
import YDExtensions
import YDUtilities
import YDB2WModels
import YDQuiz
import YDMOfflineOrders
import YDB2WCustomerIdentifier

public typealias YDMOfflineAccount = YDMOfflineAccountCoordinator

public class YDMOfflineAccountCoordinator: HistoricNavigationDelegate {
  // Properties
  var rootNavigationController: UINavigationController?
  var navigationController: UINavigationController?
  var currentUser: YDCurrentCustomer!
  
  var homeViewModel: HomeViewModelDelegate?
  var userDataViewModel: UserDataViewModelDelegate?

  // MARK: Init
  public init() {}

  // MARK: Actions
  public func start(navCon: UINavigationController?, user: YDCurrentCustomer) {
    let viewController = PreHomeViewController()

    currentUser = user

    let viewModel = PreHomeViewModel(navigation: self)
    viewController.viewModel = viewModel

    rootNavigationController = navCon
    rootNavigationController?.pushViewController(viewController, animated: true)
  }

  func startHome() {
    guard let viewController = HomeViewController.initializeFromStoryboard()
    else {
      fatalError("HomeViewController.initializeFromStoryboard")
    }

    homeViewModel = HomeViewModel(navigation: self, user: currentUser)
    
    if let extras = YDIntegrationHelper.shared.getFeature(featureName: YDConfigKeys.store.rawValue)?.extras {
      if let customerIdentifierEnabled = extras[YDConfigProperty.offlineAccountCustomerIdentifierEnable.rawValue] as? Bool {
        homeViewModel?.customerIdentifierEnabled = customerIdentifierEnabled
        
      }
      
      if let flagNewCustomerIdentifierEnable = extras[YDConfigProperty.showBadgeNewCustomerIdentifierEnable.rawValue] as? Bool {
        homeViewModel?.flagNewCustomerIdentifierEnable = flagNewCustomerIdentifierEnable
      }
    }
    
    viewController.viewModel = homeViewModel

    navigationController?.pushViewController(viewController, animated: false)
  }

  func onExit() {
    rootNavigationController?.popViewController(animated: true)
  }

  func onBack() {
    navigationController?.popViewController(animated: true)
  }
}

extension YDMOfflineAccountCoordinator: PreHomeNavigationDelegate {
  func assignInternalNavigationController(_ nav: UINavigationController?) {
    navigationController = nav
    navigationController?.restorationIdentifier = YDConstants.Miscellaneous.OfflineAccount
    startHome()
  }
}

// MARK: Home
extension YDMOfflineAccountCoordinator: HomeViewModelNavigationDelegate {
  func openCustomerIdentifier() {
    YDCustomerIdentifier().start(user: currentUser)
  }
  
  func openUserData() {
    guard let viewController = UserDataViewController.initializeFromStoryboard()
    else {
      fatalError("UserDataViewController.initializeFromStoryboard")
    }

    userDataViewModel = UserDataViewModel(
      navigation: self,
      user: currentUser
    )
    
    if let quizEnabled = YDIntegrationHelper.shared
        .getFeature(featureName: YDConfigKeys.store.rawValue)?
        .extras?[YDConfigProperty.quizEnabled.rawValue] as? Bool {
      userDataViewModel?.quizEnabled = quizEnabled
    }

    viewController.viewModel = userDataViewModel

    navigationController?.pushViewController(viewController, animated: true)
  }

  func openOfflineOrders() {
    YDMOfflineOrders().start(navController: navigationController)
  }
}

// MARK: User Data Navigation
extension YDMOfflineAccountCoordinator: UserDataNavigationDelegate {
  func openUserHistoric(withUser user: YDLasaClientLogin) {
    guard let viewController = HistoricViewController.initializeFromStoryboard()
    else {
      fatalError("HistoricViewController.initializeFromStoryboard")
    }

    let viewModel = HistoricViewModel(
      navigation: self,
      currentUser: user
    )

    viewController.viewModel = viewModel
    navigationController?.pushViewController(viewController, animated: true)
  }

  func openTerms() {
    guard let viewController = TermsViewController.initializeFromStoryboard(),
          let customViewPath = YDIntegrationHelper.shared
            .getFeature(featureName: YDConfigKeys.customerSupportService.rawValue)?
            .extras?[YDConfigProperty.urlPrivacyPolicy.rawValue] as? String
    else {
      fatalError("TermsViewController.initializeFromStoryboard")
    }

    let viewModel = TermsViewModel(
      navigation: self,
      customViewPath: customViewPath
    )

    viewController.viewModel = viewModel
    navigationController?.pushViewController(viewController, animated: true)
  }
  
  func openQuiz() {
    YDQuiz().start(user: currentUser)
  }
}

// MARK: Terms Navigation
extension YDMOfflineAccountCoordinator: TermsNavigationDelegate {}
