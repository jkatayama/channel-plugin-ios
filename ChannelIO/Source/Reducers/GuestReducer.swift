//
//  GuestReducer.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 8..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import ReSwift

func guestReducer(action: Action, guest: CHGuest?) -> CHGuest {
  var guest = guest
  switch action {
  case let action as CheckInSuccess:
    if let key = action.payload["guestKey"] as? String {
      PrefStore.setCurrentGuestKey(key)
    }
    if let user = action.payload["user"] as? CHUser {
      PrefStore.setCurrentUserId(userId: user.id)
      return user
    } else if let veil = action.payload["veil"] as? CHVeil {
      PrefStore.setCurrentVeilId(veilId: veil.id)
      return veil
    }
    return guest ?? CHVeil()
    
  case let action as UpdateGuest:
    if var guest = action.payload {
      let count = mainStore.state.sessionsState.localSessions
        .reduce(0) { count, session in count + session.alert }
      guest.alert = guest.alert + count
      return guest
    }
    return guest ?? CHVeil()
    
  case let action as CreateLocalUserChat:
    if var guest = guest, let session = action.session {
      guest.alert = guest.alert + session.alert
      return guest
    }
    return guest ?? CHVeil()
    
  case let action as UpdateGuestWithLocalRead:
    let count = action.session?.alert ?? 0
    if var guest = guest {
      let adjustCount = guest.alert - count
      guest.alert = adjustCount > 0 ? adjustCount : 0
      return guest
    }
    return guest ?? CHVeil()
    
  case _ as CheckOutSuccess:
    return CHVeil()
    
  default:
    return guest ?? CHVeil()
  }
}

