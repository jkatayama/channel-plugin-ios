//
//  PluginReducer.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 8..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import ReSwift

func pluginReducer(action: Action, plugin: CHPlugin?) -> CHPlugin {
  switch action {
  case let action as GetPlugin:
    return action.plugin
    
  case let action as GetTouchSuccess:
    return action.payload.plugin ?? CHPlugin()

  case let action as BootSuccess:
    return action.payload.plugin ?? CHPlugin()
    
  case let action as UpdateLoungeInfo:
    return action.plugin
    
  case _ as ShutdownSuccess:
    return CHPlugin()
    
  default:
    return plugin ?? CHPlugin()
  }
}
