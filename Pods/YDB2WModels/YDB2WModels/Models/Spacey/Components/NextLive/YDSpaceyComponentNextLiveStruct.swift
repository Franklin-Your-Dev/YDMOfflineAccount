//
//  YDSpaceyComponentNextLiveStruct.swift
//  YDB2WModels
//
//  Created by Douglas Hennrich on 16/08/21.
//

import Foundation

public enum YDSpaceyNextLiveShowOnlyFirstEnum: String, Decodable {
  case yes = "sim"
  case no = "não"
}

public class YDSpaceyComponentNextLiveStruct: YDSpaceyComponentDelegate {
  public var id: String?
  public var children: [YDSpaceyComponentsTypes]
  public var type: YDSpaceyComponentsTypes.Types
  public var title: String?
  public var buttonTitle: String?
  public var showOnlyFirstItem: YDSpaceyNextLiveShowOnlyFirstEnum?
  
  // MARK: CodingKeys
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case children
    case type
    case title = "liveTitle"
    case buttonTitle = "nextLiveButtonTitle"
    case showOnlyFirstItem
  }
  
  // MARK: Init
  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    type = try container.decode(YDSpaceyComponentsTypes.Types.self, forKey: .type)

    let throwables = try? container.decode(
      [Throwable<YDSpaceyComponentsTypes>].self,
      forKey: .children
    )
    children = throwables?.compactMap { try? $0.result.get() } ?? []

    // Optionals
    id = try? container.decode(String.self, forKey: .id)
    title = try? container.decode(String.self, forKey: .title)
    buttonTitle = try? container.decode(String.self, forKey: .buttonTitle)
    showOnlyFirstItem = try? container.decode(YDSpaceyNextLiveShowOnlyFirstEnum.self, forKey: .showOnlyFirstItem)
  }
}
