//
//  SettingInteractor.swift
//  ChannelIO
//
//  Created by Haeun Chung on 23/04/2019.
//  Copyright © 2019 ZOYI. All rights reserved.
//

import Foundation
import ReSwift
import RxSwift
import RxCocoa

class SettingInteractor: SettingInteractorProtocol {
  weak var presenter: SettingPresenterProtocol?
  
  var channel: CHChannel? = nil
  var plugin: CHPlugin? = nil
  var guest: CHGuest? = nil
  var showCloseChat: Bool? = nil
  var showTranslation: Bool? = nil
  var locale: CHLocale? = nil
  
  var updateSignal = PublishRelay<CHGuest>()
  var updateOptionSignal = PublishRelay<Any?>()
  var updateGeneralSignal = PublishRelay<(CHChannel, CHPlugin)>()
  
  func subscribeDataSource() {
    mainStore.subscribe(self)
  }
  
  func unsubscribeDataSource() {
    mainStore.unsubscribe(self)
  }
  
  func getChannel() -> Observable<CHChannel> {
    return ChannelPromise.getChannel()
  }
  
  func getProfileSchemas() -> Observable<[CHProfileSchema]> {
    return PluginPromise.getProfileSchemas(pluginId: mainStore.state.plugin.id)
  }
  
  func getCurrentLocale() -> CHLocale? {
    return ChannelIO.settings?.locale
  }
  
  func getTranslationEnabled() -> Bool {
    return mainStore.state.userChatsState.showTranslation
  }
  
  func updateGuest() -> Observable<CHGuest> {
    return self.updateSignal.asObservable()
  }
  
  func updateOptions() -> Observable<Any?> {
    return self.updateOptionSignal.asObservable()
  }
  
  func updateGeneral() -> Observable<(CHChannel, CHPlugin)> {
    return self.updateGeneralSignal.asObservable()
  }
}

extension SettingInteractor: StoreSubscriber {
  func newState(state: AppState) {
    if self.channel != state.channel ||
      self.plugin != state.plugin {
      self.channel = state.channel
      self.plugin = state.plugin
      self.updateGeneralSignal.accept((state.channel, state.plugin))
    }
    
    if self.guest == nil || self.guest?.diff(state.guest) == true {
      self.guest = state.guest
      self.updateSignal.accept(state.guest)
    }
    
    if self.locale != ChannelIO.settings?.locale ||
      self.showTranslation != state.userChatsState.showTranslation ||
      self.showCloseChat != state.userChatsState.showCompletedChats {
      self.locale = ChannelIO.settings?.locale
      self.showTranslation = state.userChatsState.showTranslation
      self.showCloseChat = state.userChatsState.showCompletedChats
      self.updateOptionSignal.accept(nil)
    }
  }
}
