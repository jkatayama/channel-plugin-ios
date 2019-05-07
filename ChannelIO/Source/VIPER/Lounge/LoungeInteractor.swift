//
//  LoungeInteractor.swift
//  ChannelIO
//
//  Created by Haeun Chung on 23/04/2019.
//  Copyright © 2019 ZOYI. All rights reserved.
//

import Foundation
import ReSwift
import RxSwift

class LoungeInteractor: NSObject, LoungeInteractorProtocol {  
  var presenter: LoungePresenterProtocol?
  
  func subscribeDataSource() {
    mainStore.subscribe(self)
  }
  
  func unsubscribeDataSource() {
    mainStore.unsubscribe(self)
  }
  
  func getChannel() -> Observable<CHChannel> {
    return Observable.create({ (subscriber) -> Disposable in
      subscriber.onNext(mainStore.state.channel)
      subscriber.onCompleted()
      return Disposables.create {
        
      }
    })
  }
  
  func getPlugin() -> Observable<(CHPlugin, CHBot?)> {
    return PluginPromise.getPlugin(pluginId: mainStore.state.plugin.id)
  }
  
  func getFollowers() -> Observable<[CHManager]> {
    return CHManager.getRecentFollowers()
  }
  
  func getChats() -> Observable<[CHUserChat]> {
    return Observable.create({ (subscriber) -> Disposable in
      let signal = UserChatPromise.getChats(since: nil, limit: 4, showCompleted: true)
        .subscribe(onNext: { (data) in
          mainStore.dispatch(GetUserChats(payload: data))
          let chats = userChatsSelector(state: mainStore.state, showCompleted: true)
          subscriber.onNext(chats)
          subscriber.onCompleted()
        }, onError: { error in
          subscriber.onError(error)
        })
      return Disposables.create {
        signal.dispose()
      }
    })
  }
  
  func getExternalSource() -> Observable<Any?> {
    return Observable.create({ (subscriber) -> Disposable in
      subscriber.onNext(nil)
      subscriber.onCompleted()
      return Disposables.create {

      }
    })
  }
}

extension LoungeInteractor: StoreSubscriber {
  func newState(state: AppState) {
    //if language change update
    //if channel change update
    //if plugin change update
    //if userchats changes update
  }
}

