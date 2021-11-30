//
//  TrackingEvents+Default.swift
//  YDB2WIntegration
//
//  Created by Douglas Hennrich on 05/09/21.
//

import Foundation

public extension TrackEvents {
  var defaultParameters: [String: Any] {
    switch self {
      // Scan
      case .scan, .scanProduct, .productDetails:
        return ["tipoPagina": "LASA-Scan"]

      // Live
      case .playVideo, .productSelected, .sendLike:
        return [:]
        
      case .liveOpenChat:
        return [
          "pagetype": "Hotsite",
          "ec": "live",
          "ea": "chat"
        ]
        
      case .addToCart:
        return [
          "pagetype": "Hotsite",
          "ec": "live",
          "ea": "adicionar a cesta"
        ]
        
      case .pageView, .hotsiteLive:
        return ["pagetype": "Hotsite"]
        
      case .liveNPS:
        return ["platform": "iOS"]
        
      // Pre Live
      case .preLivePageView, .nextLivesPageView:
        return ["pagetype": "Hotsite"]
        
      case .preLiveVideoPlay:
        return [
          "pagetype": "Hotsite",
          "ec": "live",
          "ea": "play"
        ]
        
      case .preLiveSchedulePushNotification:
        return [
          "pagetype": "Hotsite",
          "ec": "live",
          "ea": "adicionar calendario"
        ]
        
      case .preLiveAddToCalendar:
        return [
          "pagetype": "Hotsite",
          "ec": "live",
          "ea": "adicionar calendario"
        ]
        
      case .preLiveOpenNextLives:
        return [
          "pagetype": "Hotsite",
          "ec": "live",
          "ea": "programacao completa",
          "el": "0"
        ]
        
      // After Live
      case .afterLive:
        return [:]
        
      case .afterLiveAddToCalendar:
        return [
          "ec": "live",
          "ea": "adicionar calendario"
        ]
        
      case .afterLiveOpenNextLives:
        return [
          "ec": "live",
          "ea": "programacao completa"
        ]
        
      case .afterLiveSchedulePushNotification:
        return [
          "pagetype": "Hotsite",
          "ec": "live",
          "ea": "adicionar calendario"
        ]
        
      // Next Lives
      case .nextLivesAddToCalendar:
        return [
          "pagetype": "Hotsite",
          "ec": "live",
          "ea": "agendamento"
        ]

      // Store
      case .storePageView, .storeOnScan, .storeOpenMap:
        return [
          "pageType": "O2O-modoloja"
        ]
        
      case .storeOpenBooklet:
        return [
          "pageType": "O2O-modoloja",
          "ec": "modoloja",
          "ea": "encarte",
          "el": "sucesso"
        ]
        
      case .storeOpenBasket:
        return [
          "pageType": "O2O-modoloja",
          "ec": "modoloja",
          "ea": "ver produto",
          "el": "sucesso"
        ]
        
      case .storeModeInsideLasa:
        return [
          "pageType": "O2O-modoloja",
          "ec": "modoloja",
          "ea": "localização",
          "el": "sucesso"
        ]
        
      case .storeOnScanInsideLasa:
        return [
          "pageType": "O2O-modoloja",
          "ec": "modoloja",
          "ea": "scan dentro da loja",
          "el": "sucesso"
        ]

      // Store Mode NPS
      case .storeModeNPS,

           .sendNPS,

           // Find a Store
           .findStore,
           .findStoreViewDenied,

           // Offline Account
           .offlineAccountPerfil,
           .offlineAccountUsersInfo,
           .offlineAccountModalNonexistent,
           .offlineAccountModalIncomplete,
           .offlineAccountModalError,
           .offlineAccountHistoric,
           .offlineAccountTerms,

           // Offline Orders
           .offlineOrders,
           .offlineOrdersSuccess,
           .offlineOrdersOrderDetails,
           .offlineOrdersNPS,
           .offlineOrdersProductDetails,
        
           // Tax Coupon
           .taxCoupon,
        
           // Quiz
           .quizSocialSecurity,
           .quizQuizzesFinished,
           .quizIncompleteRegistration,
           .quizRegistrationNotFound:
        return ["pageType": "O2O-modoloja"]
        
      // Miscellaneous
      case .nps:
        return [
          "npsVersion": "v1"
        ]
    }
  }
}
