//
//  SettingReducer.swift
//  ChannelIO
//
//  Created by Haeun Chung on 09/04/2018.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import ReSwift

func settingReducer(action: Action, state: ChannelPluginSettings?) -> ChannelPluginSettings? {
  switch action {
  case let action as CheckInSuccess:
    if let settings = action.payload["settings"] as? ChannelPluginSettings {
      return settings
    }
    return state ?? ChannelPluginSettings()
  case _ as CheckOutSuccess:
    return nil
  case let action as UpdateLocale:
    state?.locale = action.payload
    return state ?? ChannelPluginSettings()
  default:
    return state ?? ChannelPluginSettings()
  }
}
