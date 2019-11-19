//
//  CHChannel.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 1. 18..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

struct CHChannel: CHEntity {
  // ModelType
  var id = ""
  // Avatar
  var avatarUrl: String?
  var initial = ""
  var color = ""
  // Channel
  var name = ""
  var domain = ""
  var country = ""
  var desc = ""
  var defaultPluginId = ""
  var textColor = "white"
  var working = true
  var workingTime: [String:TimeRange]?
  var lunchTime: TimeRange?
  var phoneNumber: String?
  var requestGuestInfo = true
  var messengerPlan: ChannelPlanType = .none
  var pushBotPlan: ChannelPlanType = .none
  var supportBotPlan: ChannelPlanType = .none
  var blocked = false
  var homepageUrl = ""
  var expectedResponseDelay = ""
  var timeZone = ""
  var utcOffset = ""
  var awayOption: ChannelAwayOptionType = .active
  var workingType: ChannelWorkingType = .always
  var trial = true
  var trialEndDate: Date? = nil
}

extension CHChannel {
  var defaultPluginLink: String {
    return "https://\(self.domain).channel.io"
  }
  
  var canUseSDK: Bool {
    return !self.blocked && (self.messengerPlan == .pro || self.trial)
  }
  
  var canUsePushBot: Bool {
    return !self.blocked && (self.pushBotPlan != .none || self.trial)
  }
  
  var canUseSupportBot: Bool {
    return !self.blocked && (self.supportBotPlan != .none || self.trial)
  }
  
  var shouldHideLauncher: Bool {
    return self.awayOption == .hidden && !self.working
  }
  
  var allowNewChat: Bool {
    return self.workingType == .always ||
      self.awayOption == .active ||
      (self.workingType == .custom && self.working)
  }
  
  var shouldShowWorkingTimes: Bool {
    if let workingTime = self.workingTime, workingTime.count != 0 {
      return self.workingType == .custom && !self.working
    }
    return false
  }
  
  var sortedWorkingTime: [SortableWorkingTime]? {
    guard var workingTime = self.workingTime else { return nil }
    
    if let launchTime = self.lunchTime {
      workingTime["lunch_time"] = launchTime
    }
    
    return workingTime.map({ (key, value) -> SortableWorkingTime in
      let fromValue = value.from
      let toValue = value.to
      
      if fromValue == 0 && toValue == 0 {
        return SortableWorkingTime(value: "", key: key, order: 0)
      }
      
      let from = min(1439, fromValue)
      let to = min(1439, toValue)
      let fromTxt = from >= 720 ? "PM" : "AM"
      let toTxt = to >= 720 ? "PM" : "AM"
      let fromMin = from % 60
      let fromHour = from / 60 > 12 ? from / 60 - 12 : from / 60
      let toMin = to % 60
      let toHour = to / 60 > 12 ? to / 60 - 12 : to / 60
      
      let timeStr = String(
        format: "%@ - %d:%02d%@ ~ %d:%02d%@",
        CHAssets.localized("ch.out_of_work.\(key)"),
        fromHour, fromMin, fromTxt, toHour, toMin, toTxt
      )
      
      var order = 0
      switch key.lowercased() {
      case "sun": order = 1
      case "mon": order = 2
      case "tue": order = 3
      case "wed": order = 4
      case "thu": order = 5
      case "fri": order = 6
      case "sat": order = 7
      default: order = 8
      }
      
      return SortableWorkingTime(value: timeStr, key: key.lowercased(), order: order)
    })
    .sorted(by: { (wt, otherWt) -> Bool in
      return wt.order < otherWt.order
    })
    .filter({ $0.value != "" })
  }
  
  var workingTimeString: String {
    return self.sortedWorkingTime?
      .compactMap({ (wt) -> String? in
        return wt.value
      })
      .joined(separator: "\n") ?? "unknown"
  }
  
  //return closest weekday and time left in minutes
  func closestWorkingTime(from date: Date) -> (nextTime: Date, timeLeft: Int)? {
    guard self.workingType == .custom else { return nil }
    guard let workingTime = self.workingTime else { return nil }
    
    var workingTimes = DateUtils.emptyArrayWithWeekday()
    var breakTimes = DateUtils.emptyArrayWithWeekday()
    
    for (dayString, range) in workingTime {
      if let day = Weekday(rawValue: dayString) {
        workingTimes[day]?.append(range)
      }
    }
    
    if let lunchTime = self.lunchTime {
      for day in breakTimes.keys {
        breakTimes[day]?.append(lunchTime)
      }
    }

    for (day, ranges) in workingTimes {
      if let otherRanges = breakTimes[day] {
        workingTimes[day] = DateUtils.substract(ranges: ranges, otherRanges: otherRanges)
      }
    }

    if workingTimes.reduce(true, { (result, workingTime) in
      return result && workingTime.value.count == 0
    }) {
      return nil
    }
    
    //convert to remote date
    guard let remoteTime = date.convertTimeZone(with: self.timeZone) else { return nil }
    //get weekday, minutes result
    if let result = DateUtils.getClosestTimeFromWeekdayRange(date: remoteTime, weekdayRange: workingTimes) {
      if remoteTime.minutes == result.time && remoteTime.weekday == result.weekday {
        //is in working hour...
        return (date, 0)
      }
      
      //this point, either before working time or after working time
      guard let nextDate = Date().next(weekday: result.weekday, mintues: result.time) else { return nil }
      
      //get weekday and left hours
      let components = date.diff(from: nextDate, components: [.hour, .minute,])
      if let hours = components.hour, let minutes = components.minute {
        let totalMinutes = hours * 60 + minutes
        return (nextDate, totalMinutes)
      }
      return nil
    }
    
    return nil
  }
}

extension CHChannel {
  static func get() -> Observable<CHChannel> {
    return ChannelPromise.getChannel()
  }
}

extension CHChannel: Equatable {
  static func == (lhs:CHChannel, rhs:CHChannel) -> Bool {
    return lhs.id == rhs.id &&
      lhs.avatarUrl == rhs.avatarUrl &&
      lhs.initial == rhs.initial &&
      lhs.color == rhs.color &&
      lhs.name == rhs.name &&
      lhs.domain == rhs.domain &&
      lhs.phoneNumber == rhs.phoneNumber &&
      lhs.working == rhs.working &&
      lhs.textColor == rhs.textColor &&
      lhs.expectedResponseDelay == rhs.expectedResponseDelay &&
      lhs.messengerPlan == lhs.messengerPlan &&
      lhs.trial == rhs.trial &&
      lhs.awayOption == rhs.awayOption &&
      lhs.workingType == rhs.workingType &&
      lhs.allowNewChat == rhs.allowNewChat
  }
}

extension CHChannel: Mappable {
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    id                      <- map["id"]
    avatarUrl               <- map["avatarUrl"]
    initial                 <- map["initial"]
    color                   <- map["color"]
    name                    <- map["name"]
    domain                  <- map["domain"]
    desc                    <- map["description"]
    defaultPluginId         <- map["defaultPluginId"]
    country                 <- map["country"]
    textColor               <- map["textColor"]
    phoneNumber             <- map["phoneNumber"]
    working                 <- map["working"]
    workingTime             <- map["workingTime"]
    lunchTime               <- map["lunchTime"]
    requestGuestInfo        <- map["requestGuestInfo"]
    homepageUrl             <- map["homepageUrl"]
    expectedResponseDelay   <- map["expectedResponseDelay"] //delayed
    timeZone                <- map["timeZone"]
    utcOffset               <- map["utcOffset"]
    messengerPlan           <- map["messengerPlan"]
    pushBotPlan             <- map["pushBotPlan"]
    supportBotPlan          <- map["supportBotPlan"]
    blocked                 <- map["blocked"]
    workingType             <- map["workingType"] //always, never, custom
    awayOption              <- map["awayOption"] //active, disabled, hidden
    trial                   <- map["trial"]
    trialEndDate            <- (map["trialEndDate"], CustomDateTransform())
  }
}

struct TimeRange {
  var from = 0
  var to = 0
}

extension TimeRange : ExpressibleByArrayLiteral {
  typealias ArrayLiteralElement = Int
  
  init(arrayLiteral elements: Int...) {
    precondition(elements.count == 2)
    self.from = elements[0]
    self.to = elements[1]
  }
}

extension TimeRange : Mappable, Equatable {
  init?(map: Map) { }
  
  mutating func mapping(map: Map) {
    from <- map["from"]
    to <- map["to"]
  }
  
  static func == (lhs:TimeRange, rhs:TimeRange) -> Bool {
    return lhs.from == rhs.from && lhs.to == lhs.to
  }
}

struct SortableWorkingTime {
  let value: String
  let key: String
  let order: Int
}

enum ChannelPlanType: String {
  case none
  case standard
  case pro
}

enum ChannelWorkingType: String {
  case always
  case never
  case custom
}

enum ChannelAwayOptionType: String {
  case active
  case disabled
  case hidden
}
