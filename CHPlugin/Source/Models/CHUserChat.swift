//
//  UserChat.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 1. 14..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftDate
import RxSwift

struct CHUserChat: ModelType {
  // ModelType
  var id = ""
  // UserChat
  var personType: String = ""
  var personId: String = ""
  var channelId: String = ""
  var bindFromId: String = ""
  var state: String = ""
  var review: String = ""
  var createdAt: Date?
  var openedAt: Date?
  var updatedAt: Date?
  var followedAt: Date?
  var resolvedAt: Date?
  var followedBy: String = ""
  
  var lastMessageId: String?
  var talkedManagerId: String?
  var resolutionTime: Int = 0
  
  var readableUpdatedAt: String {
    if let updatedAt = self.lastMessage?.createdAt {
      let now = DateInRegion()
      let updatedAt = DateInRegion(absoluteDate: updatedAt, in: Date.defaultRegion)
      let suffix = updatedAt.hour >= 12 ? "PM" : "AM"
      let hour = updatedAt.hour > 12 ? updatedAt.hour - 12 : updatedAt.hour
      if updatedAt.isToday {
        return String(format:"%d:%02d %@", hour, updatedAt.minute, suffix)
      } else if updatedAt.year == now.year {
        return "\(updatedAt.month)/\(updatedAt.day)"
      }
      return "\(updatedAt.year)/\(updatedAt.month)/\(updatedAt.day)"
    }
    return ""
  }
  
  var name: String {
//    if self.managers.count > 1 {
//      return CHAssets.localized("ch.user_chat_managers").replace("%s", withString: self.managers.first!.name).replace("%d", withString: "\(self.managers.count - 1)")
//    } else if self.managers.count == 1 {
//      return self.managers.first!.name
//    }
//
    if let manager = self.lastTalkedManager {
      return manager.name
    }
    return self.channel?.name ?? CHAssets.localized("ch.unknown")
  }

  // Dependencies
  var lastMessage: CHMessage?
  var session: CHSession?
  var lastTalkedManager: CHManager?
  var channel: CHChannel?
}

extension CHUserChat: Mappable {
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    id               <- map["id"]
    personType       <- map["personType"]
    personId         <- map["personId"]
    channelId        <- map["channelId"]
    bindFromId       <- map["bindFromId"]
    state            <- map["state"]
    review           <- map["review"]
    createdAt        <- (map["createdAt"], CustomDateTransform())
    openedAt         <- (map["openedAt"], CustomDateTransform())
    followedAt       <- (map["followedAt"], CustomDateTransform())
    resolvedAt       <- (map["resolvedAt"], CustomDateTransform())
    updatedAt        <- (map["updatedAt"], CustomDateTransform())
    followedBy       <- map["followedBy"]
    lastMessageId    <- map["lastMessageId"]
    talkedManagerId <- map["talkedManagerId"]
    
    resolutionTime   <- map["resolutionTime"]
  }
}

//TODO: Refactor to AsyncActionCreator
extension CHUserChat {
  
  static func get(userChatId: String) -> Observable<ChatResponse> {
    return UserChatPromise.getChat(userChatId: userChatId)
  }
  
  static func getChats(
    since: Int64?=nil,
    sortOrder: String,
    showCompleted: Bool = false) -> Observable<[String: Any]> {
    return UserChatPromise.getChats(
      since: since,
      limit: 30,
      sortOrder: sortOrder,
      showCompleted: showCompleted)
  }
  
  static func create() -> Observable<ChatResponse> {
    return UserChatPromise.createChat()
  }
  
  func remove() -> Observable<Any?> {
    return UserChatPromise.remove(userChatId: self.id)
  }
  
  func feedback(rating: String) -> Observable<ChatResponse> {
    return UserChatPromise.done(userChatId: self.id, rating: rating)
  }
  
  func readAll() -> Observable<Any?> {
    return UserChatPromise
      .setMessageReadAll(userChatId: self.id)
  }
}

extension CHUserChat {
  func isActive() -> Bool {
    return self.state != "closed" && self.state != "resolved"
  }
  
  func isClosed() -> Bool {
    return self.state == "closed"
  }
  
  func isReady() -> Bool {
    return self.state == "ready" || self.state == "open"
  }
}

extension CHUserChat: Equatable {
  static func ==(lhs: CHUserChat, rhs: CHUserChat) -> Bool {
    return lhs.id == rhs.id &&
      lhs.session?.alert == rhs.session?.alert &&
      lhs.lastMessageId == rhs.lastMessageId &&
      lhs.state == rhs.state
  }
}
