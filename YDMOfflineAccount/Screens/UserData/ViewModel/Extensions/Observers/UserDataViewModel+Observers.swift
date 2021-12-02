//
//  UserDataViewModel+Observers.swift
//  YDMOfflineAccount
//
//  Created by Douglas Hennrich on 30/11/21.
//

import Foundation
import YDUtilities
import YDB2WComponents
import YDB2WIntegration

extension UserDataViewModel {
  func configureObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(fromQuizSuccess),
      name: YDConstants.Notification.QuizSuccess,
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(fromQuizWrongAnswer),
      name: YDConstants.Notification.QuizWrongAnswer,
      object: nil
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(fromQuizExit),
      name: YDConstants.Notification.QuizExit,
      object: nil
    )
  }
  
  @objc func fromQuizSuccess() {
    getUsersInfo()
    snackBarMessage.value = "Seus dados foram atualizados com sucesso"
  }
  
  @objc func fromQuizWrongAnswer(_ notification: Notification) {
    let autoExit = notification.userInfo?["autoExit"] as? Bool ?? false
    
    let title = autoExit ?
      "poxa, não encontramos os seus dados" :
      "poxa, ainda não temos seu cadastro completo"
    
    let message = "Mas, não se preocupe: pra gente te ajudar a entender o que aconteceu, mande um e-mail pra atendimento.acom@americanas.com"
    
    let dialog = YDDialog()
    dialog.callback = { [weak self] _, _ in
      guard let self = self else { return }
      self.onBack()
    }
    
    dialog.onLinkCallback = { [weak self] linkOpt in
      guard let self = self else { return }
      
      let parameters = autoExit ?
        TrackEvents.quizIncompleteRegistration.parameters(body: [:]) :
        TrackEvents.quizRegistrationNotFound.parameters(body: [:])
      
      YDIntegrationHelper.shared.trackEvent(
        withName: autoExit ? .quizIncompleteRegistration : .quizRegistrationNotFound,
        ofType: .action,
        withParameters: parameters
      )
      
      self.emailDialog.fire()
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
  }
  
  @objc func fromQuizExit() {
    onBack()
  }
}
