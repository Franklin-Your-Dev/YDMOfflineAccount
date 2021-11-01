//
//  YDQuizViewModel.swift
//  YDQuiz
//
//  Created by Douglas Hennrich on 27/06/21.
//

import Foundation
import YDExtensions
import YDUtilities
import YDB2WServices
import YDB2WModels
import YDB2WIntegration

// MARK: Navigation
protocol YDQuizNavigationDelegate: AnyObject {
  func onQuizExit()
  func onWrongAnswer()
  func onQuizSuccess()
}

// MARK: Delegate
protocol YDQuizHomeViewModelDelegate: AnyObject {
  var loading: Binder<Bool> { get }
  var loadingQuizzes: Binder<Bool> { get }
  var error: Binder<String?> { get }
  var socialSecurityError: Binder<Bool> { get }
  var quizzes: Binder<[YDB2WModels.YDQuiz]> { get set }
  
  subscript(index: Int) -> YDB2WModels.YDQuiz? { get }
  func onExit()
  func validate(socialSecurity: String)
  func wrongAnswer()
  func reachLastStep()
  func validateQuizzes()
}

// MARK: ViewModel
class YDQuizHomeViewModel {
  // MARK: Properties
  lazy var logger = Logger.forClass(Self.self)
  let navigation: YDQuizNavigationDelegate
  let service: YDB2WServiceLasaClientDelegate
  var user: YDCurrentCustomer
  var userSocialSecurity = ""
  
  var loading = Binder(false)
  var loadingQuizzes = Binder(false)
  var error: Binder<String?> = Binder(nil)
  var socialSecurityError = Binder(false)
  
  var howManyRandomQuizzes = 4
  
  var allQuizzes: [YDB2WModels.YDQuiz] = []
  var quizzes: Binder<[YDB2WModels.YDQuiz]> = Binder([])
  
  // MARK: Init
  init(
    navigation: YDQuizNavigationDelegate,
    service: YDB2WServiceLasaClientDelegate = YDB2WService(),
    user: YDCurrentCustomer
  ) {
    self.navigation = navigation
    self.service = service
    self.user = user
    
    self.trackEvent(.quizSocialSecurity, ofType: .state)
  }
  
  // MARK: Actions
  private func trackEvent(
    _ name: TrackEvents,
    ofType type: TrackType,
    withParameters parameters: [String: Any]? = nil
  ) {
    YDIntegrationHelper.shared.trackEvent(
      withName: name,
      ofType: type,
      withParameters: parameters
    )
  }
  
  func getRandomQuizzes() -> [YDB2WModels.YDQuiz] {
    return Array(allQuizzes.shuffled().prefix(howManyRandomQuizzes))
  }
  
  func getNeowayToken() {
    service.neowayAuthorizationToken { [weak self] response in
      guard let self = self else { return }
//      self.error.fire()
//      return;
      
      switch response {
        case .success(let token):
          self.getQuizzes(token: token)
          
        case .failure(let error):
          self.logger.error(error.message)
          self.error.value = error.message
      }
    }
  }
  
  func getQuizzes(token: String) {
    loadingQuizzes.value = true
    
    //
    service.getLasaClientQuizzes(
      neowayToken: token,
      userSocialSecurity: userSocialSecurity
    ) { [weak self] result in
      guard let self = self else { return }
      
      switch result {
        case .success(let quizzes):
          self.allQuizzes = quizzes
          //quizzes.forEach { print($0.answer) }
          
          self.quizzes.value = self.getRandomQuizzes()
          self.loadingQuizzes.value = false
          
        case .failure(let error):
          self.logger.error(error.message)
          self.error.value = error.message
      }
    }
  }
  
  private func onSocialSecuritySuccess(client: YDLasaClientLogin, socialSecurity: String) {
    user.clientLasaToken = client.token
    user.clientLasaStoreId = client.idLasa
    userSocialSecurity = socialSecurity
    getNeowayToken()
  }
  
  private func onUpdateEmailSuccess() {
    let parameters = TrackEvents.quizQuizzesFinished.parameters(body: [:])
    trackEvent(.quizQuizzesFinished, ofType: .action, withParameters: parameters)
    
    navigation.onQuizSuccess()
  }
}

// MARK: Extend Delegate
extension YDQuizHomeViewModel: YDQuizHomeViewModelDelegate {
  subscript(index: Int) -> YDB2WModels.YDQuiz? {
    return quizzes.value.at(index)
  }
  
  func onExit() {
    navigation.onQuizExit()
  }
  
  func validate(socialSecurity: String) {
    loading.value = true
    
    let onlyNumbers = socialSecurity.replacingOccurrences(
      of: "[^0-9]",
      with: "",
      options: .regularExpression
    )
    
//    userSocialSecurity = onlyNumbers
//    getNeowayToken()
//    #warning("MOCK")
//    return;
    
    let parameters = TrackEvents.quizSocialSecurity.parameters(body: [:])
    trackEvent(.quizSocialSecurity, ofType: .action, withParameters: parameters)
    
    service.getLasaClientLogin(
      user: user,
      socialSecurity: onlyNumbers
    ) { [weak self] (result: Result<YDLasaClientLogin, YDServiceError>) in
      guard let self = self else { return }
      
      switch result {
        case .success(let client):
          self.onSocialSecuritySuccess(client: client, socialSecurity: onlyNumbers)
          
        case .failure(let error):
          self.loading.value = false
          self.logger.error(error.message)
          
          if case .permanentRedirect = error {
            self.socialSecurityError.fire()
          } else {
            self.error.value = error.message
          }
      }
    }
  }
  
  func wrongAnswer() {
    YDManager.Quiz.shared.increment()
    navigation.onWrongAnswer()
  }
  
  func reachLastStep() {
    trackEvent(.quizQuizzesFinished, ofType: .state)
  }
  
  func validateQuizzes() {
//    Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
//      self.navigation.onQuizSuccess()
//    }
//    return;
    
    service.updateLasaClientEmail(of: user, isDebug: false) { [weak self] response in
      guard let self = self else { return }
      
      switch response {
        case .success:
          self.onUpdateEmailSuccess()
          
        case .failure(let error):
          self.logger.error(error.message)
          self.error.value = error.message
      }
    }
  }
}
