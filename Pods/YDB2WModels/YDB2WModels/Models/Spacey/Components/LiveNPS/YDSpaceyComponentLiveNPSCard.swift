//
//  YDSpaceyComponentLiveNPSCard.swift
//  YDB2WModels
//
//  Created by Douglas Hennrich on 21/06/21.
//

import UIKit

public class YDSpaceyComponentLiveNPSCard: Decodable {
  public var id: String?
  public var quizzId: String?
  public var children: [YDSpaceyComponentLiveNPSCardQuestion]
  public var type: YDSpaceyComponentsTypes.Types = .liveNPSCard
  public var title: String?

  public var storedValue: String?

  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case children
    case type
    case title = "cardTitle"
  }
  
  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    children = try container.decode([YDSpaceyComponentLiveNPSCardQuestion].self, forKey: .children)
    type = try container.decode(YDSpaceyComponentsTypes.Types.self, forKey: .type)
    
    id = try? container.decodeIfPresent(String.self, forKey: .id)
    title = try? container.decodeIfPresent(String.self, forKey: .title)
  }

  public init(
    id: String?,
    children: [YDSpaceyComponentLiveNPSCardQuestion],
    title: String?
  ) {
    self.id = id
    self.children = children
    self.title = title
  }
}
