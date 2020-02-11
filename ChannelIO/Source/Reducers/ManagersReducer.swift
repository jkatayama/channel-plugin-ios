//
//  ManagerReducer.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 8..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import ReSwift

func managersReducer(action: Action, state: ManagersState?) -> ManagersState {
  var state = state
  switch action {
  case let action as GetUserChats:
    let managers = (action.payload["managers"] as? [CHManager]) ?? []
    return state?.upsert(managers: managers) ?? ManagersState()
    
  case let action as GetUserChat:
    let managers = action.payload.managers ?? []
    return state?.upsert(managers: managers) ?? ManagersState()
    
  case let action as UpdateManager:
    return state?.upsert(managers: [action.payload]) ?? ManagersState()
    
  case let action as UpdateFollowingManagers:
    return state?.upsertFollowing(managers: action.payload) ?? ManagersState()
    
  case let action as GetPush:
    return state?.upsert(manager: action.payload.manager) ?? ManagersState()
    
  case let action as UpdateLoungeInfo:
    if let managers = action.userChatsResponse?.managers {
       _ = state?.upsert(managers: managers) ?? ManagersState()
    }
    return state?.upsert(managers: action.operators) ?? ManagersState()
   
    
  case _ as ShutdownSuccess:
    return state?.clear() ?? ManagersState()
    
  default:
    return state ?? ManagersState()
  }
}
