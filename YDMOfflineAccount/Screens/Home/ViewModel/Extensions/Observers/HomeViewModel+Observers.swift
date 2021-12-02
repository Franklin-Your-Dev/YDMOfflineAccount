//
//  HomeViewModel+Observers.swift
//  YDMOfflineAccount
//
//  Created by Douglas Hennrich on 30/11/21.
//

import Foundation
import YDUtilities
import YDB2WComponents
import YDB2WIntegration

extension HomeViewModel {  
  func addQuizObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(fromQuizWrongAnswer),
      name: YDConstants.Notification.QuizWrongAnswer,
      object: nil
    )
  }
  
  func removeQuizObservers() {
    NotificationCenter.default.removeObserver(
      self,
      name: YDConstants.Notification.QuizWrongAnswer,
      object: nil
    )
  }
  
  @objc func fromQuizWrongAnswer(_ notification: Notification) {
    removeQuizObservers()
    
    let autoExit = notification.userInfo?["autoExit"] as? Bool ?? false
    
    let title = autoExit ?
      "poxa, não encontramos os seus dados" :
      "poxa, ainda não temos seu cadastro completo"
    
    let message = "Mas, não se preocupe: pra gente te ajudar a entender o que aconteceu, mande um e-mail pra atendimento.acom@americanas.com"
    
    let dialog = YDDialog()
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
}
