//
//  YDLoginDialogCoordinator.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 04/11/20.
//

import UIKit
import YDExtensions

// MARK: Delegate
public protocol YDLoginDialogDelegate: AnyObject {
  func onLoginYDLoginDialog()
  func onBackYDLoginDialog()
}

public typealias YDLoginDialog = YDLoginDialogCoordinator

public class YDLoginDialogCoordinator {
  // MARK: Properties
  var rootViewController: UIViewController {
    return self.navigationController
  }

  lazy var navigationController: UINavigationController = {
    let nav = UINavigationController()
    nav.isNavigationBarHidden = true
    nav.modalPresentationStyle = .fullScreen
    return nav
  }()

  public weak var delegate: YDLoginDialogDelegate?

  // MARK: Init
  public init() {}

  // MARK: Actions
  public func start() {
    guard let viewController = YDLoginDialogViewController.initializeFromStoryboard() else {
      fatalError("YDLoginDialogViewController.initializeFromStoryboard")
    }

    let topViewController = UIWindow.keyWindow?.rootViewController?.topMostViewController()

    let viewModel = YDLoginDialogViewModel(navigation: self)

    viewController.viewModel = viewModel

    navigationController.viewControllers = [viewController]
    navigationController.modalPresentationStyle = .overCurrentContext
    navigationController.modalTransitionStyle = .crossDissolve
    topViewController?.present(navigationController, animated: true)
  }
}

extension YDLoginDialogCoordinator: YDLoginDialogNavigationDelegate {
  func onExit() {
    rootViewController.dismiss(animated: true) { [weak self] in
      self?.delegate?.onBackYDLoginDialog()
    }
  }

  func onLogin() {
    rootViewController.dismiss(animated: true) { [weak self] in
      self?.delegate?.onLoginYDLoginDialog()
    }
  }
}
