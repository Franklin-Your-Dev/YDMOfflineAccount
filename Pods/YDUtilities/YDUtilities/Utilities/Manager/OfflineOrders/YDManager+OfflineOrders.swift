//
//  YDManager+OfflineOrders.swift
//  YDUtilities
//
//  Created by Douglas Hennrich on 21/09/21.
//

import Foundation
import YDExtensions
import YDB2WModels

public extension YDManager {
  class OfflineOrders {
    // MARK: Properties
    public static let shared = YDManager.OfflineOrders()
    
    private let defaults = UserDefaults.standard
    private var orders: [YDOfflineOrdersOrder] = []
    private var currentUserId = ""
    private var repliedNPSIds: [String] = []

    // MARK: Init
    private init() {}
  }
}


// MARK: Create
extension YDManager.OfflineOrders {
  private func saveOrders() {
    guard let encoded = try? JSONEncoder().encode(orders) else { return }
    defaults.set(encoded, forKey: YDConstants.UserDefaults.savedOfflineOrders + currentUserId)
  }
  
  private func saveRepliedNPS() {
    guard let encoded = try? JSONEncoder().encode(repliedNPSIds) else { return }
    defaults.set(
      encoded,
      forKey: YDConstants.UserDefaults.repliedOfflineOrdersNPS + currentUserId
    )
  }
}

// MARK: Retrieve
extension YDManager.OfflineOrders {
  private func getOrdersFromUsersDefaults() {
    guard let data = defaults.object(
      forKey: YDConstants.UserDefaults.savedOfflineOrders + currentUserId
    ) as? Data,
          let saved = try? JSONDecoder().decode([YDOfflineOrdersOrder].self, from: data)
    else { return }

    orders = saved
  }
  
  private func getRepliedNPSIdsFromUsersDefaults() {
    guard let data = defaults.object(
      forKey: YDConstants.UserDefaults.repliedOfflineOrdersNPS + currentUserId
    ) as? Data,
          let saved = try? JSONDecoder().decode([String].self, from: data)
    else { return }

    repliedNPSIds = saved
  }
  
  public func load(withId id: String) {
    currentUserId = id
    orders = []
    repliedNPSIds = []
    getOrdersFromUsersDefaults()
    getRepliedNPSIdsFromUsersDefaults()
  }
  
  public func retrieve() -> [YDOfflineOrdersOrder] { orders }
  
  public func alreadyRepliedNPS(for id: String) -> Bool {
    repliedNPSIds.contains(id)
  }
}

// MARK: Update
extension YDManager.OfflineOrders {
  public func store(_ orders: [YDOfflineOrdersOrder]) {
    self.orders = orders
    saveOrders()
  }
  
  public func replyNPSOrder(withId id: String) {
    repliedNPSIds.append(id)
    saveRepliedNPS()
  }
}

// MARK: Destroy
extension YDManager.OfflineOrders {
  public func cleanUp() {
    currentUserId = ""
    orders.removeAll()
    repliedNPSIds.removeAll()
  }
}
