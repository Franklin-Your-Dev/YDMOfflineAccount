//
//  TrackingEvents+Parameters.swift
//  YDB2WIntegration
//
//  Created by Douglas Hennrich on 05/09/21.
//

import Foundation

public extension TrackEvents {
  func parameters(body: [String: Any]) -> [String: Any] {
    switch self {
      // Scan
      case .scan, .scanProduct, .productDetails:
        return [:]

      // Live
      case .pageView:
        let videoId = body["videoId"] as? String ?? ""

        return [
          "tipoPagina": "Hotsite",
          "&&pageName": "ACOM:Hotsite:youtube-live",
          "deepLinkUrl": "acom://navigation/hotsite/youtube-live?videoId=\(videoId)&autoplay=true",
          "slugPath": "/hotsite/youtube-live?videoId=\(videoId)&autoplay=true"
        ]

      case .playVideo:
        let videoId = body["videoId"] as? String ?? ""

        return ["videoId": videoId]

      case .addToCart:
        let productId = body["productId"] as? String ?? ""
        let sku = body["productEan"] as? String ?? ""
        let sellerId = body["sellerId"] as? String ?? ""
        let liveName = body["liveName"] as? String ?? ""

        return [
          "productId": productId,
          "sku": sku,
          "sellerId": sellerId,
          "el": liveName
        ]

      case .productSelected:
        let productId = body["productId"] as? String ?? ""
        let sku = body["productEan"] as? String ?? ""
        let sellerId = body["sellerId"] as? String ?? ""

        return [
          "productId": productId,
          "sku": sku,
          "sellerId": sellerId
        ]
        
      case .hotsiteLive:
        return [:]

      case .liveOpenChat:
        return [
          "el": body["liveName"] as? String ?? ""
        ]
        
      case .liveNPS:
        let userId = body["userId"] as? String ?? ""
        let liveId = body["liveId"] as? String ?? ""
        let quizzId = body["quizzId"] as? String ?? ""
        let title = body["title"] as? String ?? ""
        let answer = body["value"] as? String ?? ""

        return [
          "customerId": userId,
          "liveId": liveId,
          "quizzId": quizzId,
          "question": title,
          "answer": answer
        ]

      case .sendLike:
        return [:]
        
      // PreLive
      case .preLivePageView, .preLiveOpenNextLives:
        return [:]
        
      case .preLiveVideoPlay, .preLiveSchedulePushNotification, .preLiveAddToCalendar:
        return ["el": body["liveName"] as? String ?? ""]
        
      // After Live
      case .afterLive:
        return [:]
        
      case .afterLiveAddToCalendar, .afterLiveSchedulePushNotification, .afterLiveOpenNextLives:
        return ["el": body["liveName"] as? String ?? ""]

      // Next Lives
      case .nextLivesPageView:
        return [:]

      case .nextLivesAddToCalendar:
        let liveName = body["liveName"] as? String ?? ""

        return [
          "ec": "live",
          "ea": "agendamento",
          "el": liveName
        ]

      // Store
      case .storePageView:
        let locationEnable = body["locationEnable"] as? Bool ?? false
        return ["locationEnable": locationEnable]

      case .storeOpenBasket, .storeOpenBooklet,
           .storeOnScan, .storeOpenMap, .sendNPS,
           .storeModeInsideLasa, .storeOnScanInsideLasa:
        return [:]

      case .storeModeNPS:
        if body.isEmpty { return [:] }

        let question = body["question"] ?? ""
        let value = body["value"] ?? ""
        let starType = body["starType"] as? Bool ?? false

        var parameters: [String: Any] = [
          "ec": "modoloja",
          "ea": question
        ]

        if starType {
          parameters["nota"] = value
        } else {
          parameters["el"] = value
        }

        return parameters

      // Find a Store
      case .findStore:
        let action = body["ea"] as? String ?? ""

        return [
          "ec": "modoloja",
          "ea": action,
          "el": "sucesso"
        ]
        
      case .findStoreViewDenied:
        return [:]

      // Offline Account
      case .offlineAccountUsersInfo,
           .offlineAccountModalNonexistent,
           .offlineAccountModalIncomplete,
           .offlineAccountModalError,
           .offlineAccountTerms:
        return [:]
        
      case .offlineAccountHistoric:
        return [
          "ec": "modoloja",
          "ea": "exportar relatórios",
          "el": "sucesso"
        ]
        
      case .offlineAccountPerfil:
        let action = body["ea"] as? String ?? ""

        return [
          "ec": "modoloja",
          "ea": action,
          "el": "sucesso"
        ]

      // Offline Orders
      case .offlineOrders:
        return [:]
        
      case .offlineOrdersSuccess:
        return [
          "ec": "modoloja",
          "ea": "detalhes da compra",
          "el": "sucesso"
        ]
        
      case .offlineOrdersOrderDetails:
        let action = body["ea"] as? String ?? ""
        
        return [
          "ec": "modoloja",
          "ea": action,
          "el": "sucesso"
        ]
        
      case .offlineOrdersNPS:
        return [
          "ec": "modoloja",
          "ea": "nps detalhes da compra",
          "el": "sucesso"
        ]
        
        
      case .offlineOrdersProductDetails:
        let action = body["ea"] as? String ?? ""
        
        return [
          "ec": "modoloja",
          "ea": action,
          "el": "sucesso"
        ]
      
      // Tax Coupon
      case .taxCoupon:
        return [
          "ec": "modoloja",
          "ea": "compartilhar cupom fiscal",
          "el": "sucesso"
        ]
        
      // Quiz
      case .quizSocialSecurity:
        return [
          "ec": "modoloja",
          "ea": "digitou CPF no quiz",
          "el": "sucesso"
        ]
        
      case .quizQuizzesFinished:
        return [
          "ec": "modoloja",
          "ea": "e-mail salvo no Quiz",
          "el": "sucesso"
        ]
        
      case .quizIncompleteRegistration:
        return [
          "ec": "modoloja",
          "ea": "cadastro incompleto",
          "el": "sucesso"
        ]
        
      case .quizRegistrationNotFound:
        return [
          "ec": "modoloja",
          "ea": "cadastro sem dados",
          "el": "sucesso"
        ]
        
      // Miscellaneous
      case .nps:
        let userId = body["userId"] as? String ?? ""
        let answerType = body["type"] as? String ?? ""
        let question = body["question"] as? String ?? ""
        let answer = body["answer"] as? String ?? ""
        let storeId = body["storeId"] as? String ?? ""
        let maxValue = body["maxValue"] as? String ?? ""
        
        return [
          "customerId": userId,
          "answerType": answerType,
          "question": question,
          "answer": answer,
          "maxValue": maxValue,
          "storeId": storeId
        ]
    }
  }
}
