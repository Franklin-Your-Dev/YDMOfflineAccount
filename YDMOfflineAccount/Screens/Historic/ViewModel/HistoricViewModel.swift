//
//  HistoricViewModel.swift
//  YDMstoreModeOfflineAccount
//
//  Created by Douglas Hennrich on 02/02/21.
//

import Foundation

import YDUtilities
import YDExtensions
import YDB2WIntegration
import YDB2WServices
import YDB2WModels

// MARK: Navigation
protocol HistoricNavigationDelegate {
  func onBack()
}

// MARK: Delegate
protocol HistoricViewModelDelegate {
  var error: Binder<Bool> { get }
  var loading: Binder<Bool> { get }
  var historicList: Binder<[YDLasaClientHistoricData]> { get }

  subscript(index: Int) -> YDLasaClientHistoricData? { get }
  func onBack()
  func getHistoricList()
  func trackExportMetric()
}

class HistoricViewModel {
  // MARK: Properties
  let service: YDB2WServiceDelegate
  let navigation: HistoricNavigationDelegate

  var error: Binder<Bool> = Binder(false)
  var loading: Binder<Bool> = Binder(false)

  var historicList: Binder<[YDLasaClientHistoricData]> = Binder([])
  let user: YDLasaClientLogin

  // MARK: Init
  init(
    service: YDB2WServiceDelegate = YDB2WService(),
    navigation: HistoricNavigationDelegate,
    currentUser: YDLasaClientLogin
  ) {
    self.service = service
    self.navigation = navigation
    self.user = currentUser

    YDIntegrationHelper.shared
      .trackEvent(withName: .offlineAccountHistoric, ofType: .state)
  }

  // MARK: Actions
  func getMock() -> [YDLasaClientHistoricData] {
    let bundle = Bundle(for: type(of: self))

    guard let pathString = bundle.path(forResource: "historicMock", ofType: "json"),
          let data = try? Data(contentsOf: URL(fileURLWithPath: pathString)),
          let json = try? JSONDecoder().decode([YDLasaClientHistoricData].self, from: data)
    else {
      fatalError()
    }

    return json
  }
}

// MARK: Extension
extension HistoricViewModel: HistoricViewModelDelegate {
  subscript(index: Int) -> YDLasaClientHistoricData? {
    return historicList.value.at(index)
  }

  func onBack() {
    navigation.onBack()
  }

  func getHistoricList() {
    loading.value = true
//    Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
//      self.historicList.value = self.getMock()
//      self.loading.value = false
//    }

    service.getLasaClientHistoric(
      with: user
    ) { [weak self] (result: Result<[YDLasaClientHistoricData], YDServiceError>) in
      guard let self = self else { return }
      self.loading.value = false

      switch result {
        case .success(let historic):
          self.historicList.value = historic

        case .failure(let error):
          debugPrint(#function, error.message)
          self.error.fire()
      }
    }
  }
  
  func trackExportMetric() {
    let parameters = TrackEvents.offlineAccountHistoric.parameters(body: [:])
    
    YDIntegrationHelper.shared.trackEvent(
      withName: .offlineAccountHistoric,
      ofType: .action,
      withParameters: parameters
    )
  }
}
