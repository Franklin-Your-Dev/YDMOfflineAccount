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
          "category": "live",
          "action": "chat"
        ]
        
      case .addToCart:
        return [
          "pagetype": "Hotsite",
          "category": "live",
          "action": "adicionar a cesta"
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
          "category": "live",
          "action": "play"
        ]
        
      case .preLiveSchedulePushNotification:
        return [
          "pagetype": "Hotsite",
          "category": "live",
          "action": "adicionar calendario"
        ]
        
      case .preLiveAddToCalendar:
        return [
          "pagetype": "Hotsite",
          "category": "live",
          "action": "adicionar calendario"
        ]
        
      case .preLiveOpenNextLives:
        return [
          "pagetype": "Hotsite",
          "category": "live",
          "action": "programacao completa",
          "eventLabel": "0"
        ]
        
      // After Live
      case .afterLive:
        return [:]
        
      case .afterLiveAddToCalendar:
        return [
          "category": "live",
          "action": "adicionar calendario"
        ]
        
      case .afterLiveOpenNextLives:
        return [
          "category": "live",
          "action": "programacao completa"
        ]
        
      case .afterLiveSchedulePushNotification:
        return [
          "pagetype": "Hotsite",
          "category": "live",
          "action": "adicionar calendario"
        ]
        
      // Next Lives
      case .nextLivesAddToCalendar:
        return [
          "pagetype": "Hotsite",
          "category": "live",
          "action": "agendamento"
        ]

      // Store
      case .storePageView, .storeOnScan, .storeOpenMap:
        return [
          "pageType": "O2O-modoloja"
        ]
        
      case .storeOpenBooklet:
        return [
          "pageType": "O2O-modoloja",
          "category": "modoloja",
          "action": "encarte",
          "label": "sucesso"
        ]
        
      case .storeOpenBasket:
        return [
          "pageType": "O2O-modoloja",
          "category": "modoloja",
          "action": "ver produto",
          "label": "sucesso"
        ]
        
      case .storeModeInsideLasa:
        return [
          "pageType": "O2O-modoloja",
          "category": "modoloja",
          "action": "localização",
          "label": "sucesso"
        ]
        
      case .storeOnScanInsideLasa:
        return [
          "pageType": "O2O-modoloja",
          "category": "modoloja",
          "action": "scan dentro da loja",
          "label": "sucesso"
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
