//
//  YDDialogCoordinator.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 17/11/20.
//

import UIKit
import YDExtensions

// MARK: Delegate
public protocol YDDialogCoordinatorDelegate: AnyObject {
  func onActionYDDialog(payload: [String: Any]?)
  func onCancelYDDialog(payload: [String: Any]?)
}

extension YDDialogCoordinatorDelegate {
  func onCancelYDDialog(payload: [String: Any]?) {}
}

public typealias YDDialog = YDDialogCoordinator

public class YDDialogCoordinator {
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

  public weak var delegate: YDDialogCoordinatorDelegate?

  public var payload: [String: Any]?
  
  public var callback: ((_ fromAction: Bool, _ payload: [String: Any]?) -> Void)?

  // MARK: Init
  public init() {}

  // MARK: Actions
  public func start(
    ofType type: YDDialogType = .withIcon,
    customIcon: UIImage? = nil,
    customTitle: String? = nil,
    customMessage: String? = nil,
    customButton: String? = nil,
    customCancelButton: String? = nil,
    messageLink: [String: String]? = nil,
    messagesToBold: [String]? = nil
  ) {
    guard let viewController = YDDialogViewController.initializeFromStoryboard() else {
      fatalError("YDDialogViewController.initializeFromStoryboard")
    }

    let topViewController = UIWindow.keyWindow?.rootViewController?.topMostViewController()

    let viewModel = YDDialogViewModel(navigation: self)

    viewController.viewModel = viewModel
    viewController.type = type

    viewController.customIcon = customIcon
    viewController.customTitle = customTitle
    viewController.customMessage = customMessage
    viewController.customButton = customButton
    viewController.customCancelButton = customCancelButton
    viewController.messageLink = messageLink
    viewController.messagesToBold = messagesToBold

    navigationController.viewControllers = [viewController]
    navigationController.modalPresentationStyle = .overCurrentContext
    navigationController.modalTransitionStyle = .crossDissolve
    topViewController?.present(navigationController, animated: true)
  }
}

extension YDDialogCoordinator: YDDialogNavigationDelegate {
  public func onAction() {
    rootViewController.dismiss(animated: true) { [weak self] in
      guard let self = self else { return }
      
      if self.callback != nil {
        self.callback?(true, self.payload)
        return
      }
      
      self.delegate?.onActionYDDialog(payload: self.payload)
    }
  }

  public func onCancelAction() {
    rootViewController.dismiss(animated: true) { [weak self] in
      guard let self = self else { return }
      
      if self.callback != nil {
        self.callback?(false, self.payload)
        return
      }
      
      self.delegate?.onCancelYDDialog(payload: self.payload)
    }
  }
}
