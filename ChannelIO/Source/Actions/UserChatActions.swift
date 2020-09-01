//
//  UserChatActions.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 8..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import ReSwift

struct FetchedUserChatPrep: Action {
  public let followers: [CHManager]
  public let plugin: CHPlugin
  public let bot: CHBot?
  public let supportBotEntry: CHSupportBotEntryInfo
}

struct GetUserChats: Action {
  public let payload: UserChatsResponse
}

struct FailedGetUserChats: Action {
  public let error: Error
}

struct GetMessages: Action {
  public let payload: [String: Any]
}

//struct FailedGetMessages: Action {
//  public let error: Error
//}

struct RemoveMessages: Action {
  public let payload: String?
}

struct GetUserChat: Action {
  public let payload: ChatResponse
}

struct CreateUserChat: Action {
  public let payload: CHUserChat
}

struct UpdateUserChat: Action {
  public let payload: CHUserChat
}

struct DeleteUserChat: Action {
  public let payload: CHUserChat
}

struct DeleteUserChats: Action {
  public let payload: [CHUserChat]
}

struct DeleteUserChatsAll: Action {}

struct JoinedUserChat: Action {
  public let payload: String
}

struct LeavedUserChat: Action {
  public let payload: String
}

//Update user
struct UpdateUser: Action {
  public let payload: CHUser?
}

struct UpdateVisibilityOfCompletedChats: Action {
  public let show: Bool? 
}

struct UpdateVisibilityOfTranslation: Action {
  public let show: Bool?
}

struct UserChatActions {
  static func openAgreement() {
    let locale = CHUtils.getLocale() ?? .korean
    let url = "https://channel.io/"
      + locale.rawValue
      + "/terms_user?plugin_key="
      + (ChannelIO.bootConfig?.pluginKey ?? "")
    
    guard let link = URL(string: url) else { return }
    link.open()
  }
}

