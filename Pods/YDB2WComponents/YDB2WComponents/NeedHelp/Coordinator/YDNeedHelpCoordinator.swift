//
//  YDNeedHelpCoordinator.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 29/09/21.
//

import UIKit
import YDExtensions
import YDB2WColors

public typealias YDNeedHelp = YDNeedHelpCoordinator

public protocol YDNeedHelpDelegate: AnyObject {
  func openForm()
}

public class YDNeedHelpCoordinator {
  // MARK: Properties
  var rootViewController: UIViewController {
    return self.navigationController
  }
  
  lazy var navigationController: UINavigationController = {
    let nav = UINavigationController()
    nav.modalPresentationStyle = .popover
    nav.navigationBar.tintColor = YDColors.branding
    return nav
  }()
  
  weak var delegate: YDNeedHelpDelegate?
  
  // MARK: Init
  public init(delegate: YDNeedHelpDelegate) {
    self.delegate = delegate
  }
  
  // MARK: Start
  public func start() {
    let viewModel: YDNeedHelpViewModelDelegate = YDNeedHelpViewModel(navigation: self)
    let viewController = YDNeedHelpViewController()
    viewController.viewModel = viewModel
    
    navigationController.viewControllers = [viewController]
    
    let topViewController = UIApplication.shared.keyWindow?
      .rootViewController?.topMostViewController()

    topViewController?.present(navigationController, animated: true)
  }
}

// MARK: ViewModel Navigation
extension YDNeedHelpCoordinator: YDNeedHelpViewModelNavigation {
  func onExit() {
    rootViewController.dismiss(animated: true)
  }
  
  func openForm() {
    rootViewController.dismiss(animated: true) {
      self.delegate?.openForm()
    }
  }
}
