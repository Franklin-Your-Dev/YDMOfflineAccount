//
//  TrackingEventsEnum.swift
//  YDIntegration
//
//  Created by Douglas Hennrich on 27/10/20.
//  Copyright © 2020 YourDev. All rights reserved.
//

import Foundation

public enum TrackType: String {
  case state
  case action
}

public enum TrackEventsNameSpace: String {
  case lives
  case store = "store-mode"
}

public enum TrackEvents: String {
  // Module Scan
  case scan = "ACOM:LASA-Scan"
  case scanProduct = "ACOM:LASA-Scan:Produto"
  case productDetails = "ACOM:LASA-Scan:Produto:Detalhes"

  // Live
  case pageView = "ACOM:Live:youtube-live"
  case playVideo = "ACOM:Video:Playing"
  case productSelected = "ACOM:LiveCarousel:ProductSelected"
  case addToCart
  case liveOpenChat
  case liveNPS = "quizz"
  case sendLike = "MobileApps:LiveLikes"
  
  case hotsiteLive = "ACOM:Live"

  // Pre Live
  case preLivePageView = "ACOM:Live:Pre"
  case preLiveVideoPlay
  case preLiveSchedulePushNotification
  case preLiveAddToCalendar
  case preLiveOpenNextLives
  
  // After Live
  case afterLive = "ACOM:Live:Pos"
  case afterLiveAddToCalendar
  case afterLiveSchedulePushNotification
  case afterLiveOpenNextLives

  // Next Lives
  case nextLivesPageView = "ACOM:Live:youtube-live:proximas-lives"
  case nextLivesAddToCalendar = "ACOM:Live:youtube-live:proximas-lives:adicionar-calendario"

  // Store Mode
  case storePageView = "ACOM:MODOLOJA-Home"
  case storeModeInsideLasa = "ACOM:MODOLOJA-UsaDentroDaLoja"
  case storeOpenBasket = "ACOM:MODOLOJA-VerProdutos"
  case storeOpenBooklet = "ACOM:MODOLOJA-EncarteDasLojas"
  case storeOnScan = "ACOM:MODOLOJA-Scan"
  case storeOnScanInsideLasa = "ACOM:MODOLOJA-ScanDentroDaLoja"
  case storeOpenMap = "O2O-Home-Mapa"

  // Store Mode NPS
  case storeModeNPS = "ACOM:MODOLOJA-NpsLoja"
  case sendNPS = "StoreModeNps"

  // Find a Store
  case findStore = "ACOM:MODOLOJA-Mapa"
  case findStoreViewDenied = "ACOM:MODOLOJA-MapaSemLocalizacao"

  // Offline Account
  case offlineAccountPerfil = "ACOM:MODOLOJA-MeuPerfil"
  case offlineAccountUsersInfo = "ACOM:MODOLOJA-DadosAtualizados"
  case offlineAccountModalNonexistent = "ACOM:OfflineAccount:ModalCadastroInexistente"
  case offlineAccountModalIncomplete = "ACOM:OfflineAccount:ModalCadastroIncompleto"
  case offlineAccountModalError = "ACOM:OfflineAccount:ModalErro"
  case offlineAccountHistoric = "ACOM:MODOLOJA-Historico"
  case offlineAccountTerms = "ACOM:MODOLOJA-TermoseCondicoes"

  // Offline Orders
  case offlineOrders = "ACOM:MODOLOJA-MinhasCompras"
  case offlineOrdersSuccess = "ACOM:MODOLOJA-MinhasComprasSucesso"
  case offlineOrdersOrderDetails = "ACOM:MODOLOJA-DetalhesDaCompra"
  case offlineOrdersProductDetails = "ACOM:MODOLOJA-DetalhesDoProduto"
  case offlineOrdersNPS = "ACOM:MODOLOJA-NPSdetalhesDaCompra"
  
  // Tax Coupon
  case taxCoupon = "ACOM:MODOLOJA-CupomFiscal"
  
  // Quiz
  case quizSocialSecurity = "ACOM:MODOLOJA-QuizCPF"
  case quizQuizzesFinished = "ACOM:MODOLOJA-QuizDadosConfirmados"
  case quizIncompleteRegistration = "ACOM:MODOLOJA-CadastroIncompleto"
  case quizRegistrationNotFound = "ACOM:MODOLOJA-CadastroSemDados"
  
  // Miscellaneous
  case nps
  
  public var eventName: String {
    switch self {
      case .addToCart, .pageView, .liveOpenChat:
        return TrackEvents.pageView.rawValue
        
      case .preLivePageView,
           .preLiveVideoPlay,
           .preLiveSchedulePushNotification,
           .preLiveAddToCalendar,
           .preLiveOpenNextLives:
        return  TrackEvents.hotsiteLive.rawValue
        
      case .afterLive,
           .afterLiveAddToCalendar,
           .afterLiveSchedulePushNotification,
           .afterLiveOpenNextLives:
        return TrackEvents.afterLive.rawValue
      
      default:
        return self.rawValue
    }
  }
}
