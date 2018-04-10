//
//  AppState.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 1. 15..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import ReSwift

struct AppState: StateType {
  var checkinState: CheckinState
  var plugin: CHPlugin
  var channel: CHChannel
  var guest: CHGuest
  var userChatsState: UserChatsState
  var push: CHPush?
  var managersState: ManagersState
  var botsState: BotsState
  var sessionsState: SessionsState
  var messagesState: MessagesState
  var uiState: UIState
  var socketState: WSocketState
  var scriptsState: ScriptsState
  var countryCodeState: CountryCodeState
  var settings: ChannelPluginSettings?
}

enum CHLocale: String {
  case english = "en"
  case korean = "ko"
  case japanese = "ja"
}
