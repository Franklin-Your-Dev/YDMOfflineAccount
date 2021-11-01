//
//  YDSpaceyComponentLiveNPS.swift
//  YDB2WModels
//
//  Created by Douglas Hennrich on 05/07/21.
//

import Foundation

public class YDSpaceyComponentLiveNPS: YDSpaceyComponentDelegate {
  // MARK: Properties
  public var id: String?
  public var quizzId: String?
  public var title: String?
  public var type: YDSpaceyComponentsTypes.Types
  public var children: [YDSpaceyComponentsTypes]
  public var cards: [YDSpaceyComponentLiveNPSCard]

  // MARK: CodingKeys
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case quizzId
    case title = "npsTitle"
    case type
    case children
  }

  // MARK: Init
  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    type = try container.decode(YDSpaceyComponentsTypes.Types.self, forKey: .type)
    children = []
    
    // Optionals
    id = try container.decodeIfPresent(String.self, forKey: .id)
    quizzId = try container.decodeIfPresent(String.self, forKey: .quizzId)
    title = try container.decodeIfPresent(String.self, forKey: .title)

    let throwables = try? container.decode(
      [Throwable<YDSpaceyComponentLiveNPSCard>].self,
      forKey: .children
    )
    cards = throwables?.compactMap { try? $0.result.get() } ?? []
    cards.forEach { $0.quizzId = quizzId }
  }

  public init(
    id: String?,
    cards: [YDSpaceyComponentLiveNPSCard]
  ) {
    self.id = id
    self.cards = cards

    self.type = .liveNPS
    self.children = []
  }
}
