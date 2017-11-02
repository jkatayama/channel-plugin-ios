//
//  UIReducer.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 13..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import ReSwift

func uiReducer(action: Action, state: UIState?) -> UIState {
  var state = state
  switch action {
  case _ as ShowProfile:
    state?.profileIsHidden = false
    return state ?? UIState()
  case _ as HideProfile:
    state?.profileIsHidden = true
    return state ?? UIState()
  case _ as ChannelIsShown:
    state?.isChannelVisible = true
    return state ?? UIState()
  case _ as ChannelIsHidden:
    state?.isChannelVisible = false
    return state ?? UIState()
  default:
    return state ?? UIState()
  }
}

func checkinReducer(action: Action, state: CheckinState?) -> CheckinState {
  var state = state
  switch action {
  case let action as UpdateCheckinState:
    state?.status = action.payload
    return state ?? CheckinState()
  default:
    return state ?? CheckinState()
  }
}
