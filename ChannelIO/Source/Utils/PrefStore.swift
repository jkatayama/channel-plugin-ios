//
//  PrefStore.swift
//  CHPlugin
//
//  Created by Haeun Chung on 06/02/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation

class PrefStore {
  static let CHANNEL_ID_KEY = "CHPlugin_ChannelId"
  static let USER_ID_KEY = "CHPlugin_UserId"
  static let PUSH_OPTION_KEY = "CHPlugin_PushOption"
  static let VISIBLE_CLOSED_USERCHAT_KEY = "CHPlugin_show_closed_userchat"
  static let CHANNEL_PLUGIN_SETTINGS_KEY = "CHPlugin_settings"
  static let VISIBLE_TRANSLATION = "CHPlugin_visible_translation"
  static let SESSION_JWT_KEY = "CHPlugin_session_jwt"
  static let VEIL_ID_KEY = "CHPlugin_veil_id"
  static let MEMBER_ID_KEY = "CHPlugin_member_id"
  
  static var userDefaults: UserDefaults? = nil
  
  static func getStorage() -> UserDefaults {
    if NSClassFromString("XCTest") != nil {
      if let userDefaults = PrefStore.userDefaults {
        return userDefaults
      } else {
        PrefStore.userDefaults = MockUserDefaults()
        return PrefStore.userDefaults!
      }
    } else {
      guard
        let bundleId = Bundle.main.bundleIdentifier,
        let group = UserDefaults(suiteName: "group.\(bundleId).channelio")
      else {
        return UserDefaults.standard
      }
      
      return group
    }
  }
  
  static func migrateIfNeeded() {
    guard
      let bundleId = Bundle.main.bundleIdentifier,
      let group = UserDefaults(suiteName: "group.\(bundleId).channelio")
    else {
      return
    }
    
    let stringKeys = [
      CHANNEL_ID_KEY, USER_ID_KEY, PUSH_OPTION_KEY, SESSION_JWT_KEY, VEIL_ID_KEY, MEMBER_ID_KEY
    ]
    
    let boolKeys = [VISIBLE_CLOSED_USERCHAT_KEY, VISIBLE_TRANSLATION]
    
    let dataKeys = [CHANNEL_PLUGIN_SETTINGS_KEY]
    
    stringKeys.forEach {
      group.set(UserDefaults.standard.string(forKey: $0), forKey: $0)
      UserDefaults.standard.removeObject(forKey: $0)
    }
    
    boolKeys.forEach {
      if let value = UserDefaults.standard.object(forKey: $0) as? Bool {
        group.set(value, forKey: $0)
        UserDefaults.standard.removeObject(forKey: $0)
      }
    }
    
    dataKeys.forEach {
      if let value = UserDefaults.standard.object(forKey: $0) as? Data {
        group.set(value, forKey: $0)
        UserDefaults.standard.removeObject(forKey: $0)
      }
    }
  }
  
  static func getCurrentUserId() -> String? {
    return PrefStore.getStorage().string(forKey: USER_ID_KEY)
  }
  
  static func setCurrentUserId(_ userId: String?) {
    if let userId = userId {
      PrefStore.getStorage().set(userId, forKey: USER_ID_KEY)
      PrefStore.getStorage().synchronize()
    }
  }
  
  static func clearCurrentUserId() {
    PrefStore.getStorage().removeObject(forKey: USER_ID_KEY)
    PrefStore.getStorage().synchronize()
  }
  
  static func getCurrentMemberId() -> String? {
    return PrefStore.getStorage().string(forKey: MEMBER_ID_KEY)
  }
  
  static func setCurrentMemberId(_ memberId: String?) {
    if let memberId = memberId {
      PrefStore.getStorage().set(memberId, forKey: MEMBER_ID_KEY)
      PrefStore.getStorage().synchronize()
    }
  }
  
  static func clearCurrentMemberId() {
    PrefStore.getStorage().removeObject(forKey: MEMBER_ID_KEY)
    PrefStore.getStorage().synchronize()
  }
  
  static func getCurrentChannelId() -> String? {
    return PrefStore.getStorage().string(forKey: CHANNEL_ID_KEY)
  }
  
  static func setCurrentChannelId(channelId: String) {
    PrefStore.getStorage().set(channelId, forKey: CHANNEL_ID_KEY)
    PrefStore.getStorage().synchronize()
  }

  static func clearCurrentChannelId() {
    PrefStore.getStorage().removeObject(forKey: CHANNEL_ID_KEY)
    PrefStore.getStorage().synchronize()
  }
  
  static func setVisibilityOfClosedUserChat(on: Bool) {
    PrefStore.getStorage().set(on, forKey: VISIBLE_CLOSED_USERCHAT_KEY)
    PrefStore.getStorage().synchronize()
  }
  
  static func getVisibilityOfClosedUserChat() -> Bool {
    if let closed = PrefStore.getStorage().object(forKey: VISIBLE_CLOSED_USERCHAT_KEY) as? Bool {
      return closed
    }
    return true
  }
  
  static func setVisibilityOfTranslation(on: Bool) {
    PrefStore.getStorage().set(on, forKey: VISIBLE_TRANSLATION)
    PrefStore.getStorage().synchronize()
  }
  
  static func getVisibilityOfTranslation() -> Bool {
    if let visible = PrefStore.getStorage().object(forKey: VISIBLE_TRANSLATION) as? Bool {
      return visible
    }
    return true
  }
  
  static func setChannelPluginSettings(pluginSetting: ChannelPluginSettings) {
    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: pluginSetting)
    PrefStore.getStorage().set(encodedData, forKey: CHANNEL_PLUGIN_SETTINGS_KEY)
    PrefStore.getStorage().synchronize()
  }
  
  static func getChannelPluginSettings() -> ChannelPluginSettings? {
    if let data = PrefStore.getStorage().object(forKey: CHANNEL_PLUGIN_SETTINGS_KEY) as? Data {
      return NSKeyedUnarchiver.unarchiveObject(with: data) as? ChannelPluginSettings
    }
    return nil
  }
  
  static func clearCurrentChannelPluginSettings() {
    PrefStore.getStorage().removeObject(forKey: CHANNEL_PLUGIN_SETTINGS_KEY)
    PrefStore.getStorage().synchronize()
  }
  
  static func setSessionJWT(_ jwt: String?) {
    if let jwt = jwt {
      PrefStore.getStorage().set(jwt, forKey: SESSION_JWT_KEY)
      PrefStore.getStorage().synchronize()
    }
  }
  
  static func getSessionJWT() -> String? {
    return PrefStore.getStorage().string(forKey: SESSION_JWT_KEY)
  }
  
  static func clearSessionJWT() {
    PrefStore.getStorage().removeObject(forKey: SESSION_JWT_KEY)
    PrefStore.getStorage().synchronize()
  }
  
  static func setVeilId(_ veilId: String?) {
    if let veilId = veilId {
      PrefStore.getStorage().set(veilId, forKey: VEIL_ID_KEY)
      PrefStore.getStorage().synchronize()
    }
  }
  
  static func getVeilId() -> String? {
    return PrefStore.getStorage().string(forKey: VEIL_ID_KEY)
  }
  
  static func clearVeilId() {
    PrefStore.getStorage().removeObject(forKey: VEIL_ID_KEY)
    PrefStore.getStorage().synchronize()
  }
  
  static func clearAllLocalData() {
    PrefStore.clearCurrentMemberId()
    PrefStore.clearCurrentChannelId()
    PrefStore.clearCurrentChannelPluginSettings()
    PrefStore.clearSessionJWT()
  }
}

class MockUserDefaults: UserDefaults {
  convenience init() {
    self.init(suiteName: "test user defaults")!
  }
  
  override init?(suiteName: String?) {
    UserDefaults().removePersistentDomain(forName: suiteName!)
    super.init(suiteName: suiteName)
  }
}
