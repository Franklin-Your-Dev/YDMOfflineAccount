//
//  YDQuizCoordinator.swift
//  YDQuiz
//
//  Created by Douglas Hennrich on 27/06/21.
//

import UIKit
import YDExtensions
import YDB2WModels
import YDUtilities
import YDB2WComponents
import YDB2WIntegration
import YDB2WColors

public typealias YDQuiz = YDQuizCoordinator

public class YDQuizCoordinator {
  // Properties
  var rootViewController: UIViewController {
    return self.navigationController
  }

  lazy var navigationController: UINavigationController = {
    let nav = UINavigationController()
    nav.navigationBar.prefersLargeTitles = false

    if #available(iOS 13.0, *) {
      let appearanceStandard = UINavigationBarAppearance()

      appearanceStandard.titleTextAttributes = [.foregroundColor:  YDColors.black]
      appearanceStandard.configureWithTransparentBackground()
      appearanceStandard.shadowImage = UIImage()
      appearanceStandard.shadowColor = .clear

      nav.navigationBar.compactAppearance = appearanceStandard
      nav.navigationBar.standardAppearance = appearanceStandard
      nav.navigationBar.scrollEdgeAppearance = appearanceStandard
    } else {
      nav.navigationBar.isTranslucent = false
      nav.navigationBar.shadowImage = UIImage()
      nav.navigationBar.titleTextAttributes = [.foregroundColor:  YDColors.black]
      nav.navigationBar.largeTitleTextAttributes = [.foregroundColor:  YDColors.black]
      nav.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
      nav.navigationBar.backgroundColor = .clear
    }

    nav.navigationBar.tintColor = YDColors.Gray.light
    return nav
  }()

  // MARK: Init
  public init() {}

  // MARK: Actions
  public func start(user: YDCurrentCustomer) {
    if !YDManager.Quiz.shared.checkIfCanOpen() {
      openDialog(withType: .wrongAnswer(autoExit: true))
      return
    }
    
    let viewModel = YDQuizHomeViewModel(navigation: self, user: user)

    let viewController = YDQuizHomeViewController()
    viewController.viewModel = viewModel

    let topViewController = UIApplication.shared.windows.first?
      .rootViewController?.topMostViewController()

    navigationController.viewControllers = [viewController]
    topViewController?.present(navigationController, animated: true)
  }
  
  func onExit(onCompletion completion: (() -> Void)?) {
    rootViewController.dismiss(animated: true, completion: completion)
  }
}

// MARK: Home Navigation
extension YDQuizCoordinator: YDQuizNavigationDelegate {
  func onWrongAnswer() {
    onExit {
      openDialog(withType: .wrongAnswer(autoExit: false))
    }
  }
  
  func onQuizSuccess() {
    onExit {
      openDialog(withType: .success)
    }
  }
  
  func onQuizExit() {
    onExit {
      openDialog(withType: .exit)
    }
  }
}

private enum QuizCallbackType {
  case success
  case exit
  case wrongAnswer(autoExit: Bool)
}

// MARK: Helper
private func openDialog(withType type: QuizCallbackType) {
  DispatchQueue.main.async {
    switch type {
      case .wrongAnswer(let autoExit):
        let title = autoExit ?
          "poooxa, ainda não temos seu cadastro completo" :
          "poooxa, não encontramos os seus dados aqui"
        let message = autoExit ?
          "Pra completar o seu cadastro entre em contato com nosso atendimento, através do e-mail: atendimento.acom@americanas.com" :
          "Você pode consultar mais informações com nosso atendimento, através do e-mail: atendimento.acom@americanas.com"
        
        let parameters = autoExit ?
          TrackEvents.quizIncompleteRegistration.parameters(body: [:]) :
          TrackEvents.quizRegistrationNotFound.parameters(body: [:])
        
        YDIntegrationHelper.shared.trackEvent(
          withName: autoExit ? .quizIncompleteRegistration : .quizRegistrationNotFound,
          ofType: .action,
          withParameters: parameters
        )
        
        let dialog = YDDialog()
        dialog.callback = { _, _ in
          NotificationCenter.default.post(
            name: YDConstants.Notification.QuizWrongAnswer,
            object: nil,
            userInfo: ["autoExit": autoExit]
          )
        }
        
        dialog.start(
          ofType: .simple,
          customTitle: title,
          customMessage: message,
          messageLink: [
            "message": "atendimento.acom@americanas.com",
            "link": "mailto:atendimento.acom@americanas.com"
          ]
        )
        
      case .success:
        NotificationCenter.default.post(name: YDConstants.Notification.QuizSuccess, object: nil)
        
      case .exit:
        NotificationCenter.default.post(name: YDConstants.Notification.QuizExit, object: nil)
    }
  }
}
