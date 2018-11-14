//
//  Session.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 1. 18..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Foundation
import ObjectMapper

struct CHSession: ModelType {
  // ModelType
  var id = ""
  // Session
  var chatType = ""
  var chatId = ""
  var personType = ""
  var personId = ""
  var unread = 0
  var alert = 0
  var readAt: Date? = nil
  var postedAt: Date? = nil
}

extension CHSession: Mappable {
  init?(map: Map) { }
  
  init(id: String, chatId: String, guest: CHGuest, alert: Int, type: String = "UserChat") {
    self.id = id
    self.chatId = chatId
    self.personType = guest.type
    self.personId = guest.id
    self.alert = alert
    self.chatType = type
  }
  
  mutating func mapping(map: Map) {
    id          <- map["id"]
    chatType    <- map["chatType"]
    chatId      <- map["chatId"]
    personType  <- map["personType"]
    personId    <- map["personId"]
    unread      <- map["unread"]
    alert       <- map["alert"]
    readAt      <- (map["readAt"], CustomDateTransform())
    postedAt    <- (map["postedAt"], CustomDateTransform())
  }
}
