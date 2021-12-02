//
//  YDMStoreModeOfflineAccountUserDataViewModel.swift
//  YDMstoreModeOfflineAccount
//
//  Created by Douglas Hennrich on 25/01/21.
//

import Foundation

import YDUtilities
import YDExtensions
import YDB2WIntegration
import YDB2WServices
import YDB2WModels
import YDB2WComponents

// MARK: Navigation
protocol UserDataNavigationDelegate {
  func onBack()
  func openUserHistoric(withUser user: YDLasaClientLogin)
  func openTerms()
  func openQuiz()
}

// MARK: Delegate
protocol UserDataViewModelDelegate {
  var error: Binder<(title: String, message: String)> { get }
  var errorView: Binder<Bool> { get }
  var loading: Binder<Bool> { get }
  var snackBarMessage: Binder<String?> { get }
  var usersInfo: Binder<[YDLasaClientDataSet]> { get }
  var userData: YDLasaClientInfo? { get set }
  var quizEnabled: Bool { get set }
  var emailDialog: Binder<Bool> { get }

  subscript(_ index: Int) -> YDLasaClientDataSet? { get }

  func onBack()
  func getUsersInfo()
  func openHistoric()
  func openTerms()
  func updateInfo()
}

class UserDataViewModel {
  // MARK: Properties
  lazy var logger = Logger.forClass(Self.self)
  let service: YDB2WServiceDelegate
  let navigation: UserDataNavigationDelegate

  var error: Binder<(title: String, message: String)> = Binder(("", ""))
  var errorView: Binder<Bool> = Binder(false)
  var loading: Binder<Bool> = Binder(false)
  var snackBarMessage: Binder<String?> = Binder(nil)

  let currentUser: YDCurrentCustomer
  var userLogin: YDLasaClientLogin? = nil
  var userData: YDLasaClientInfo? = nil
  var usersInfo: Binder<[YDLasaClientDataSet]> = Binder([])
  
  var quizEnabled = false
  
  var emailDialog: Binder<Bool> = Binder(false)

  let errorMessageIncompletePerfil = (
    title: "poooxa, ainda não temos seu cadastro completo",
    message: "E pra mantermos a segurança dos seus dados, você poderá consultar mais informações com nosso atendimento, através do e-mail: atendimento.acom@americanas.com"
  )
  let errorMessage = (
    title: "poooxa, não encontramos os seus dados aqui",
    message: "Você pode consultar mais informações com nosso atendimento, através do e-mail: atendimento.acom@americanas.com"
  )

  // MARK: Init
  init(
    service: YDB2WServiceDelegate = YDB2WService(),
    navigation: UserDataNavigationDelegate,
    user: YDCurrentCustomer
  ) {
    self.service = service
    self.navigation = navigation
    self.currentUser = user
    
    configureObservers()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: Actions
  func trackEvent(
    _ event: TrackEvents,
    ofType type: TrackType,
    withParams params: [String: Any]? = nil
  ) {
    YDIntegrationHelper.shared
      .trackEvent(withName: event, ofType: type, withParameters: params)
  }

  func getClientInfo(with user: YDLasaClientLogin) {
    userLogin = user

    service.getLasaClientInfo(
      with: user
    ) { [weak self] (result: Result<YDLasaClientInfo, YDServiceError>) in
      guard let self = self else { return }

      switch result {
        case .success(let data):
          self.userData = data
          self.usersInfo.value = data.getUserDataSets()
          self.trackEvent(.offlineAccountUsersInfo, ofType: .state)
          self.loading.value = false

        case .failure(let error):
          self.loading.value = false

          switch error {
            case .permanentRedirect:
              self.error.value = self.errorMessageIncompletePerfil
              self.trackEvent(.offlineAccountModalIncomplete, ofType: .state)

            case .notFound:
              self.error.value = self.errorMessage
              self.trackEvent(.offlineAccountModalError, ofType: .state)

            default:
              break
          }
      }
    }
  }
}

// MARK: Extension
extension UserDataViewModel: UserDataViewModelDelegate {
  subscript(_ index: Int) -> YDLasaClientDataSet? {
    return usersInfo.value.at(index)
  }

  func onBack() {
    navigation.onBack()
    NotificationCenter.default.removeObserver(self)
  }

  func getUsersInfo() {
    loading.value = true
    //    getUsersInfoMock()
    //    return;

    service.getLasaClientLogin(
      user: currentUser,
      socialSecurity: nil
    ) { [weak self] (response: Result<YDLasaClientLogin, YDServiceError>) in
      guard let self = self else { return }

      switch response {
        case .success(let userLoginData):
          self.getClientInfo(with: userLoginData)

        case .failure(let error):
          self.loading.value = false

          switch error {
            case .permanentRedirect:
              self.trackEvent(.offlineAccountModalIncomplete, ofType: .state)
              
              if self.quizEnabled {
                self.navigation.openQuiz()
              } else {
                self.error.value = self.errorMessageIncompletePerfil
              }

            case .notFound:
              self.error.value = self.errorMessage
              self.trackEvent(.offlineAccountModalError, ofType: .state)

            default:
              self.errorView.fire()
          }
      }
    }
  }

  func openHistoric() {
    guard let user = userLogin else { return }

    navigation.openUserHistoric(withUser: user)
  }

  func openTerms() {
    navigation.openTerms()
  }

  func updateInfo() {
    loading.value = true
    guard let params = try? userData?.asDictionary(),
          let userLogin = userLogin
    else {
      loading.value = false
      error.value = errorMessage
      trackEvent(.offlineAccountModalError, ofType: .state)
      return
    }

    trackEvent(
      .offlineAccountUsersInfo,
      ofType: .action,
      withParams: [
        "&ea=": "clique-botao",
        "&el=": "Página meus dados lojas fisicas"
      ]
    )

    service.updateLasaClientInfo(
      user: userLogin,
      parameters: params
    ) { [weak self] (result: Result<Void, YDServiceError>) in
      guard let self = self else { return }
      self.loading.value = false

      switch result {
        case .success:
          self.snackBarMessage.value = "Atualização de dados e permissões salvos com sucesso :)"
        case .failure:
          self.snackBarMessage.value = "Ops! Algo inesperado aconteceu. Tente novamente."
      }
    }
  }
}

// MARK: Mock
extension UserDataViewModel {
  func getUsersInfoMock() {
    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
      let jsonString = """
      {
        "id_lasa": "a3c93817-40de-43d1-9e12-0e994ac8835d",
        "nome_completo": "Natália Prado Tiago",
        "sexo": null,
        "estado_civil": null,
        "data_nascimento": "1994-10-29T00:00:00",
        "logradouro": "Rua Senador Vergueiro",
        "numero": "5",
        "complemento": "Bloco 3 apto 316 - Perto da renner",
        "municipio": "Rio de Janeiro",
        "cep": "22230000",
        "bairro": "Flamengo",
        "uf": "BR",
        "telefone_celular": "33933198",
        "telefone_residencial": "",
        "email": "nataliaprado29@gmail.com",
        "optin_marketing": false,
        "optin_termos_condicoes": false
      }
      """

      let userLoginString = """
      {
        "cpf": "13569901777",
        "nome": "Natália Prado Tiago",
        "email": "pradocinhosgourmet@gmail.com",
        "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZExhc2EiOiJhM2M5MzgxNy00MGRlLTQzZDEtOWUxMi0wZTk5NGFjODgzNWQiLCJpYXQiOjE2MTI4Nzc4NjIsImV4cCI6MTYxMjk2NDI2Mn0.HZTMQSnHJ79on1U46Wo8KyVbCHTjTAHTGeh4WAw9mR0",
        "id_lasa": "a3c93817-40de-43d1-9e12-0e994ac8835d"
      }
      """

      guard let data = jsonString.data(using: .utf16),
            let json = try? JSONDecoder().decode(YDLasaClientInfo.self, from: data),
            let dataUserLogin = userLoginString.data(using: .utf16),
            let userLogin = try? JSONDecoder().decode(YDLasaClientLogin.self, from: dataUserLogin)
      else {
        return
      }

      self.userLogin = userLogin
      self.userData = json
      self.usersInfo.value = json.getUserDataSets()

      self.loading.value = false
    }
  }
}
