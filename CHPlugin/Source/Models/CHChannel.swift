//
//  CHChannel.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 1. 18..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Foundation
import ObjectMapper

struct TimeRange {
  var from = 0
  var to = 0
}

extension TimeRange : Mappable {
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    from <- map["from"]
    to <- map["to"]
  }
}

struct CHChannel: CHEntity {
  // ModelType
  var id = ""
  // Avatar
  var avatarUrl: String?
  var initial = ""
  var color = ""
  // Channel
  var name = ""
  var country = ""
  var textColor = "white"
  var outOfWorkPlugin = false
  var working = true
  var workingTime: [String:TimeRange]?
  var phoneNumber: String = ""
  var requestGuestInfo = true
  var servicePlan = ""
  var serviceBlocked = false
  var workingTimeString: String {
    let msg = self.workingTime?.flatMap({ (key, value) -> String in
      let fromValue = value.from
      let toValue = value.to

      if fromValue == 0 && toValue == 0 {
        return ""
      }

      let from = min(1439, fromValue)
      let to = min(1439, toValue)
      let fromTxt = from >= 720 ? "PM" : "AM"
      let toTxt = to >= 720 ? "PM" : "AM"
      let fromMin = from % 60
      let fromHour = from / 60 > 12 ? from / 60 - 12 : from / 60
      let toMin = to % 60
      let toHour = to / 60 > 12 ? to / 60 - 12 : to / 60

      let result = String(format: "%@ - %d:%02d%@ ~ %d:%02d%@",
                          CHAssets.localized("ch.out_of_work.\(key)"), fromHour, fromMin, fromTxt, toHour, toMin, toTxt)
      return result
    }).filter({ $0 != "" }).joined(separator: "\n") ?? "unknown"
    return CHAssets.localized("ch.out_of_work.title") + "\n" + msg
  }
  
  func isBlocked() -> Bool {
    return self.serviceBlocked || self.servicePlan == "free"
  }
}

extension CHChannel: Mappable {
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    id                <- map["id"]
    avatarUrl         <- map["avatarUrl"]
    initial           <- map["initial"]
    color             <- map["color"]
    name              <- map["name"]
    country           <- map["country"]
    textColor         <- map["textColor"]
    phoneNumber       <- map["phoneNumber"]
    outOfWorkPlugin   <- map["outOfWorkPlugin"]
    working           <- map["working"]
    workingTime       <- map["workingTime"]
    requestGuestInfo  <- map["requestGuestInfo"]
  }
}
