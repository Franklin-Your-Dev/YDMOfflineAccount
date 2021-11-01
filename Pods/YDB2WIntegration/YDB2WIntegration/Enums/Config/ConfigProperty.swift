//
//  ConfigProperty.swift
//  YDB2WIntegration
//
//  Created by Douglas Hennrich on 07/09/21.
//

import Foundation

public enum YDConfigProperty: String {
  // Search stores
  case maxStoreRange = "acheUmaLojaFeatureNearbyStores"
  case insideLasaDistance = "distanceUserLasaStore"

  // Store Mode
  case productsQueryVersion = "lasaB2WProductsQueryVersion"
  case offlineAccountEnabled

  // Store Mode NPS
  case npsEnabled
  case npsFeedbackMessage
  case npsMinutesToPrune
  case npsSpaceyId

  // Live
  case liveSpaceyOrder = "spaceyPositionIndex"

  case liveCarrouselProductsBatches = "lazyLoadingItems"
  case liveIsProductCarouselCouponEnabled = "isProductCarouselCouponEnabled"

  case liveYouTubePlayerAutoStart
  case liveYouTubePlayerResetVideoWhenPaused
  case liveYouTubePlayerEnableFullScreenButton
  
  case liveDeletedMessageSocketEnabled = "isDeletedMessageServiceByWebSocketEnabled"
  case liveNewMessageSocketEnabled = "isNewMessageServiceByWebSocketEnabled"

  case preLiveHotsite
  
  case liveStartTimeMinusMinutes
  case checkForLiveTimerConfig
  case liveHotsiteId = "liveHotsite"
  case liveChatEnabled = "chatEnabled"

  case liveChatLikesEnabled = "chatLikesEnabled"
  case liveChatLikesSpeed = "liveChatLikeSpeed"

  case liveChatPolling
  case liveChatPollingError
  case liveChatLimit
  case liveChatSendDelay
  case liveChatModerators = "chatModerators"
  case liveHighlightMessageEnabled = "fixedMessageEnabled"

  case liveYouTubeCounter = "liveAmountPeopleWatching"
  case liveAmountPeopleWatchingPolling

  case liveNPSEnabled
  case liveNPSLiveIdEnabled
  
  case afterLiveEnabled
  case afterLiveHotsite
  case afterLivePollingTimeInSeconds = "afterLivePollingTime"
  
  // Socket
  case socketConnectionPingTime
  case socketConnectionRetryTime
  case isWebSocketForceReconectEnabled
  case socketForceReconnectTime

  // Next Lives
  case nextLiveEnabled
  case nextLiveSpaceyId = "nextLiveHotsite"
  case nextLivesReminderTimeInMinutes = "nextLivesReminderTime"

  // Google Services
  case youtubeKey

  // Lasa Client
  case lazyLoadingOrders

  // Offline Orders
  case offlineOrdersNoteEnabled = "enableOfflineOrdersNote"
  case offlineOrdersNPSEnabled = "isOfflineOrdersNpsEnabled"
  
  // Quiz
  case quizEnabled = "storeModeQuizEnabled"
  
  // Tax Coupon
  case taxCouponShareEnabled = "isTaxCouponSaveAndShareButtonsEnabled"
  
  // Miscellaneous
  case secret
  case urlPrivacyPolicy = "url_privacy_policy"
  case brandName
}
