//
//  NPSViewModel.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 19/10/21.
//

import Foundation
import YDB2WComponents
import YDB2WIntegration
import YDUtilities
import YDB2WModels

// MARK: Navigation
protocol NPSNavigation: AnyObject {
  func onBack()
  func onNPSSent(snackBarMessage: String?)
}

protocol NPSViewModelDelegate: AnyObject {
  var spaceyViewModel: YDSpaceyViewModelDelegate { get set }
  var npsComponent: Binder<YDSpaceyComponentNPS?> { get }
  var isSendButtonEnabled: Binder<Bool> { get }
  var snackBarSuccessMessage: String? { get set }
  
  func goBack()
  func getSpacey()
  func onSendButtonAction()
}

class NPSViewModel {
  // MARK: Properties
  lazy var logger = Logger.forClass(Self.self)
  let navigation: NPSNavigation
  var spaceyViewModel: YDSpaceyViewModelDelegate
  
  let storeId: String
  let orderId: String
  
  var npsComponent: Binder<YDSpaceyComponentNPS?> = Binder(nil)
  
  var isSendButtonEnabled: Binder<Bool> = Binder(false)
  
  var snackBarSuccessMessage: String? = "Obrigada! Resposta cadastrada com sucesso :)"
  
  // MARK: Init
  init(
    navigation: NPSNavigation,
    spaceyViewModel: YDSpaceyViewModelDelegate,
    storeId: String,
    orderId: String
  ) {
    self.spaceyViewModel = spaceyViewModel
    self.navigation = navigation
    
    self.storeId = storeId
    self.orderId = orderId
    
    configureSpaceyBinds()
    configureObserver()
    
    trackMetric(name: .storeModeNPS, type: .state)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: Actions
  private func trackMetric(name: TrackEvents, type: TrackType, parameters: [String: Any] = [:]) {
    YDIntegrationHelper.shared
      .trackEvent(withName: name, ofType: type, withParameters: parameters)

//    logger.info(["Event: \(name.rawValue)", "Type: \(type.rawValue)", "Payload: \(parameters)"])
  }
  
  private func buildNPSMetricPayload(
    for type: YDSpaceyComponentNPSQuestion.AnswerTypeEnum,
    question: String,
    value: Any,
    userId: String,
    storeId: String,
    maxValue: String
  ) -> [String: Any] {
    let parameters: [String: Any] = [
      "userId": userId,
      "question": question,
      "answer": "\(value)",
      "storeId": storeId,
      "maxValue": maxValue,
      "type": type.transformedToMetric
    ]

    return TrackEvents.nps.parameters(body: parameters)
  }
  
  private func allNonOptionalAnswered() -> Bool {
    npsComponent.value?.children.allSatisfy {
      guard let component = $0.get() as? YDSpaceyComponentNPSQuestion else {
        return false
      }
      
      return (component.isOptional == .no && component.storedValue != nil) ||
        component.isOptional == .yes
    } ?? false
  }
}

// MARK: Binds
extension NPSViewModel {
  func configureSpaceyBinds() {
    spaceyViewModel.spacey.bindOnce { [weak self] spaceyOpt in
      guard let self = self else { return }
      guard let spacey = spaceyOpt else { return }
      
      spacey.allComponents().forEach {
        guard let nps = $0.component as? YDSpaceyComponentNPS else {
          return
        }
        
        self.npsComponent.value = nps
      }
    }
  }
}

// MARK: Observers
extension NPSViewModel {
  private func configureObserver() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(onNPSValueChange),
      name: YDConstants.Notification.SpaceyNPSChangeValue,
      object: nil
    )
  }
  
  @objc private func onNPSValueChange() {
    isSendButtonEnabled.value = allNonOptionalAnswered()
  }
}

// MARK: Conforms to Delegate
extension NPSViewModel: NPSViewModelDelegate {
  func goBack() {
    navigation.onBack()
  }
  
  func getSpacey() {
    spaceyViewModel.getSpacey()
  }
  
  func onSendButtonAction() {
    let nps = spaceyViewModel.componentsList.value
//    let payload: [String: Any] = [
//      "storeId": storeId
//    ]
    
    let userId = YDIntegrationHelper.shared.currentUser?.id ?? ""
    
    for curr in nps {
      guard let type = curr.component?.type else { continue }

      if type == .npsQuestion {
        if let component = curr.component as? YDSpaceyComponentNPSQuestion,
           let title = component.question,
           let value = component.storedValue {
          
          var maxScore = ""
          
          if let maxScoreUnwarp = component.maxScore {
            maxScore = "\(maxScoreUnwarp)"
          }
          
          let parameters = buildNPSMetricPayload(
            for: component.answerType,
            question: title,
            value: value,
            userId: userId,
            storeId: storeId,
            maxValue: maxScore
          )
          
          YDIntegrationHelper.shared.trackStuartEvent(
            namespace: .store,
            event: .nps,
            parameters: parameters
          )
        }
      } else if type == .npsEditText {
        if let component = curr.component as? YDSpaceyComponentEditText,
           let title = component.hint {

          let parameters = buildNPSMetricPayload(
            for: .textView,
            question: title,
            value: component.storedValue ?? "",
            userId: userId,
            storeId: storeId,
            maxValue: ""
          )
          
          YDIntegrationHelper.shared.trackStuartEvent(
            namespace: .store,
            event: .nps,
            parameters: parameters
          )
        }
      }
    }

    YDManager.OfflineOrders.shared.replyNPSOrder(withId: orderId)
    
    trackMetric(name: .sendNPS, type: .action)
    
    navigation.onNPSSent(snackBarMessage: snackBarSuccessMessage)
  }
}
