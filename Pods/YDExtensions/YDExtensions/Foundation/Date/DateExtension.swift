//
//  DateExtension.swift
//  YDExtensions
//
//  Created by Douglas Hennrich on 02/11/20.
//

import Foundation

public extension Date {

  func toFormat(_ format: String = "yyyy-MM-dd") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.locale = Locale(identifier: "pt_BR")
//    dateFormatter.timeZone = TimeZone(identifier: "America/Sao_Paulo")
    return dateFormatter.string(from: self)
  }
  
  func convertToSaoPauloTimeZone() -> Date? {
    guard let saoPauloTimeZone = TimeZone(identifier: "America/Sao_Paulo") else { return nil }
    
    let targetOffset = TimeInterval(saoPauloTimeZone.secondsFromGMT(for: self))
    let localOffeset = TimeInterval(TimeZone.autoupdatingCurrent.secondsFromGMT(for: self))

    return self.addingTimeInterval(targetOffset - localOffeset)
  }

  var calendar: Calendar {
    var calendary = Calendar(identifier: .gregorian)
    calendary.locale = Locale(identifier: "pt_BR")
    
    if let zone = TimeZone(identifier: "America/Sao_Paulo") {
      calendary.timeZone = zone
    }
    
    return calendary
  }
  
  var saoPauloDate: Date? {
    guard let saoPauloTimeZone = TimeZone(identifier: "America/Sao_Paulo") else { return nil }
    let now = Date()
    let targetOffset = TimeInterval(saoPauloTimeZone.secondsFromGMT(for: now))
    let localOffeset = TimeInterval(TimeZone.autoupdatingCurrent.secondsFromGMT(for: now))

    return now.addingTimeInterval(targetOffset - localOffeset)
  }

  var isInFuture: Bool {
    guard let saoPauloDate = self.saoPauloDate,
          let normalizedDate = convertToSaoPauloTimeZone() else {
      return false
    }
    
    return normalizedDate > saoPauloDate
  }

  var isInPast: Bool {
    guard let saoPauloDate = self.saoPauloDate,
          let normalizedDate = convertToSaoPauloTimeZone() else {
      return false
    }
    
    return normalizedDate < saoPauloDate
  }

  var isInToday: Bool {
    guard let normalizedDate = convertToSaoPauloTimeZone() else {
      return false
    }
    
    return calendar.isDateInToday(normalizedDate)
  }

  var isInYesterday: Bool {
    guard let normalizedDate = convertToSaoPauloTimeZone() else {
      return false
    }
    
    return calendar.isDateInYesterday(normalizedDate)
  }

  /// SwifterSwift: Check if date is within tomorrow.
  ///
  ///   Date().isInTomorrow -> false
  ///
  var isInTomorrow: Bool {
    guard let normalizedDate = convertToSaoPauloTimeZone() else {
      return false
    }
    
    return calendar.isDateInTomorrow(normalizedDate)
  }

  /// SwifterSwift: Check if date is within a weekend period.
  var isInWeekend: Bool {
    guard let normalizedDate = convertToSaoPauloTimeZone() else {
      return false
    }
    
    return calendar.isDateInWeekend(normalizedDate)
  }

  /// SwifterSwift: Check if date is within a weekday period.
  var isWorkday: Bool {
    guard let normalizedDate = convertToSaoPauloTimeZone() else {
      return false
    }
    
    return !calendar.isDateInWeekend(normalizedDate)
  }

  /// SwifterSwift: Check if date is within the current week.
  var isInCurrentWeek: Bool {
    guard let saoPauloDate = self.saoPauloDate,
      let normalizedDate = convertToSaoPauloTimeZone() else {
      return false
    }
    
    return calendar.isDate(normalizedDate, equalTo: saoPauloDate, toGranularity: .weekOfYear)
  }

  /// SwifterSwift: Check if date is within the current month.
  var isInCurrentMonth: Bool {
    guard let saoPauloDate = self.saoPauloDate,
      let normalizedDate = convertToSaoPauloTimeZone() else {
      return false
    }
    
    return calendar.isDate(normalizedDate, equalTo: saoPauloDate, toGranularity: .month)
  }

  /// SwifterSwift: Check if date is within the current year.
  var isInCurrentYear: Bool {
    guard let saoPauloDate = self.saoPauloDate,
      let normalizedDate = convertToSaoPauloTimeZone() else {
      return false
    }
    
    return calendar.isDate(normalizedDate, equalTo: saoPauloDate, toGranularity: .year)
  }

  /// SwifterSwift: ISO8601 string of format (yyyy-MM-dd'T'HH:mm:ss.SSS) from date.
  ///
  ///   Date().iso8601String -> "2017-01-12T14:51:29.574Z"
  ///
  var iso8601String: String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "pt_BR")
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
//    dateFormatter.timeZone = TimeZone(identifier: "America/Sao_Paulo")

    return dateFormatter.string(from: self).appending("Z")
  }

  func isBetween(_ date: Date, and date2: Date) -> Bool {
    guard let normalizedDate = convertToSaoPauloTimeZone() else {
      return false
    }
    
    return normalizedDate >= date && normalizedDate <= date2
  }
}
