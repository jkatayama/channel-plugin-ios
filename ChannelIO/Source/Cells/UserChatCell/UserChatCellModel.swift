//
//  UserChatCellModel.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 1. 14..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Foundation

protocol UserChatCellModelType {
  var chatId: String? { get set }
  var title: String { get set }
  var lastMessage: String? { get set }
  var timestamp: String { get set }
  var avatar: CHEntity? { get set }
  var badgeCount: Int { get set }
  var isBadgeHidden: Bool { get set }
  var isClosed: Bool { get set }
}

struct UserChatCellModel: UserChatCellModelType {
  var chatId: String? = nil
  var title: String = ""
  var lastMessage: String? = nil
  var timestamp: String = ""
  var avatar: CHEntity? = nil
  var badgeCount: Int = 0
  var isBadgeHidden: Bool = false
  var isClosed: Bool = false
  
  init() {}
  
  init(userChat: CHUserChat) {
    self.chatId = userChat.id
    
    if userChat.state == .closed && userChat.review != "" {
      self.lastMessage = CHAssets.localized("ch.review.complete.preview")
    } else if let msg = userChat.lastMessage?.messageV2?.string, msg != "" {
      self.lastMessage = msg
    } else if let logMessage = userChat.lastMessage?.logMessage {
      self.lastMessage = logMessage
    } else {
      self.lastMessage = userChat.lastMessage?.message ?? ""
    }
    
    var avatar: CHEntity?
    if let writer = personSelector(
      state: mainStore.state,
      personType: userChat.lastMessage?.personType,
      personId: userChat.lastMessage?.personId),
      writer is CHBot {
      avatar = writer
    } else if let defaultBot = defaultBotSelector(state: mainStore.state) {
      avatar = defaultBot
    } else {
      avatar = mainStore.state.channel
    }
    
    let title = avatar?.name ?? CHAssets.localized("ch.unknown")
    
    self.title = userChat.assignee?.name ?? title
    self.timestamp = userChat.readableUpdatedAt
    self.avatar = userChat.assignee ?? avatar
    self.badgeCount = userChat.session?.alert ?? 0
    self.isBadgeHidden = self.badgeCount == 0
    self.isClosed = userChat.isClosed
  }
  
  static func welcome(with plugin: CHPlugin, guest: CHGuest, supportBotMessage: CHMessage? = nil) -> UserChatCellModel {
    var model = UserChatCellModel()
    let bot = botSelector(state: mainStore.state, botName: plugin.botName)
    model.avatar = bot ?? mainStore.state.channel
    model.title = bot?.name ?? mainStore.state.channel.name
    
    let message = supportBotMessage?.messageV2?.string ?? guest.getWelcome()
    let (mv2, _) =  CustomMessageTransform.markdown.parse(message ?? "")
    
    model.lastMessage = mv2?.string ?? ""
    model.isBadgeHidden = true
    model.badgeCount = 0
    return model
  }
}
