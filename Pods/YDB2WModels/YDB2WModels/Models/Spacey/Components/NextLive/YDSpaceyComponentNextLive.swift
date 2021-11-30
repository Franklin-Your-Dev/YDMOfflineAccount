//
//  YDSpaceyComponentNextLive.swift
//  YDB2WModels
//
//  Created by Douglas Hennrich on 27/04/21.
//

import Foundation

public class YDSpaceyComponentNextLive: Decodable {
  // MARK: Properties
  public let liveId: String?
  public let photo: String?
  public let initialDate: String?
  public let finalDate: String?
  public let name: String?
  public let description: String?
  public var liveType: LiveTypeEnum = .horizontal
  public var alreadyScheduled = false
  public let componentType: YDSpaceyComponentsTypes.Types = .nextLive

  // MARK: Computed variables
  public var finalDateAsDate: Date? {
    finalDate?.date(withFormat: "dd/MM/yyyy HH:mm")
  }

  public var initialDateAsDate: Date? {
    initialDate?.date(withFormat: "dd/MM/yyyy HH:mm")
  }

  public var formatedDate: String? {
    guard let initialDateFormat = initialDate?.date(withFormat: "dd/MM/yyyy HH:mm"),
          let finalDateFormat = finalDate?.date(withFormat: "dd/MM/yyyy HH:mm"),
          let now = Date().convertToSaoPauloTimeZone()
    else { return nil }

    let startTime = initialDateFormat.toFormat("HH:mm")
    let endTime = finalDateFormat.toFormat("HH:mm")

    if initialDateFormat.isInToday &&
        now.isBetween(initialDateFormat, and: finalDateFormat) {
      return "ao vivo • \(startTime)-\(endTime)"
    } else {
      return "\(initialDateFormat.toFormat("dd/MM '•'")) \(startTime)-\(endTime)"
    }
  }

  public var isAvailable: Bool {
    guard let initialDateFormat = initialDate?.date(withFormat: "dd/MM/yyyy HH:mm"),
          let finalDateFormat = finalDate?.date(withFormat: "dd/MM/yyyy HH:mm"),
          let now = Date().convertToSaoPauloTimeZone()
    else { return false }

    return !now.isBetween(initialDateFormat, and: finalDateFormat) && !alreadyScheduled
  }

  public var isLive: Bool {
    guard let initialDateFormat = initialDate?.date(withFormat: "dd/MM/yyyy HH:mm"),
          let finalDateFormat = finalDate?.date(withFormat: "dd/MM/yyyy HH:mm"),
          let now = Date().convertToSaoPauloTimeZone()
    else { return false }

    return now.isBetween(initialDateFormat, and: finalDateFormat)
  }

  // MARK: CodingKeys
  enum CodingKeys: String, CodingKey {
    case liveId = "_id"
    case photo = "liveImageUrl"
    case initialDate = "liveStartTime"
    case finalDate = "liveEndTime"
    case name = "liveTitle"
    case description = "liveDescription"
    case liveType = "liveVertical"
  }

  // MARK: Init
  public init(
    liveId: String? = nil,
    photo: String? = nil,
    initialDate: String? = nil,
    finalDate: String? = nil,
    name: String? = nil,
    description: String? = nil,
    liveType: LiveTypeEnum = .horizontal
  ) {
    self.liveId = liveId
    self.photo = photo
    self.initialDate = initialDate
    self.finalDate = finalDate
    self.name = name
    self.description = description
    self.liveType = liveType
  }
  
  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    liveId = try container.decodeIfPresent(String.self, forKey: .liveId)
    photo = try container.decodeIfPresent(String.self, forKey: .photo)
    initialDate = try container.decodeIfPresent(String.self, forKey: .initialDate)
    finalDate = try container.decodeIfPresent(String.self, forKey: .finalDate)
    name = try container.decodeIfPresent(String.self, forKey: .name)
    description = try container.decodeIfPresent(String.self, forKey: .description)
    
    if let liveTypeString = try? container.decode(String.self, forKey: .liveType),
       let liveType = LiveTypeEnum(rawValue: liveTypeString) {
      self.liveType = liveType
    } else {
      self.liveType = .horizontal
    }
  }
}

// MARK: Private enum
public enum LiveTypeEnum: String, Decodable {
  case vertical = "sim"
  case horizontal = "não"
}

// MARK: Sort array of NextLives
extension YDSpaceyComponentNextLive {
  public static func sort(list: [YDSpaceyComponentNextLive]) -> [YDSpaceyComponentNextLive] {
    let filteredLives = list.filter { curr in
      guard let initialDate = curr.initialDateAsDate else { return false }
      return curr.isLive || initialDate.isInFuture
    }

    let sorted = filteredLives.sorted { lhs, rhs -> Bool in
      guard let dateLhs = lhs.initialDateAsDate else { return false }
      guard let dateRhs = rhs.initialDateAsDate else { return true }

      return dateLhs.compare(dateRhs) == .orderedAscending
    }
    
    return sorted
  }
}

// MARK: Mock
public extension YDSpaceyComponentNextLive {
  static func fromMock(
    id: String,
    startTime: String? = nil,
    endTime: String? = nil
  ) -> YDSpaceyComponentNextLive {
    return YDSpaceyComponentNextLive(
      liveId: id,
//      photo: "https://miro.medium.com/max/875/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg",
      initialDate: startTime ?? "27/04/2021 15:00",
      finalDate: endTime ?? "27/04/2021 16:00",
      name: "Nome da Live",
      description: .lorem()
    )
  }
}
