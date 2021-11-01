//
//  YDSpaceyComponentLiveNPSCardQuestion.swift
//  YDB2WModels
//
//  Created by Douglas Hennrich on 21/06/21.
//

import Foundation

public class YDSpaceyComponentLiveNPSCardQuestion: Decodable {
  public var id: String?
  public var image: String?
  public var title: String?
  public var type: YDSpaceyComponentsTypes.Types = .liveNPSCardQuestion

  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case image = "questionImage"
    case title = "questionTitle"
    case type
  }

  public init(
    id: String?,
    image: String?,
    title: String?
  ) {
    self.id = id
    self.image = image
    self.title = title
  }
  
  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    id = try? container.decodeIfPresent(String.self, forKey: .id)
    image = try? container.decodeIfPresent(String.self, forKey: .image)
    title = try? container.decodeIfPresent(String.self, forKey: .title)
  }
}
