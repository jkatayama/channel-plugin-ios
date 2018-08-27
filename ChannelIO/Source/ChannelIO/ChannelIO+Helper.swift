//
//  ChannelIO+Helper.swift
//  CHPlugin
//
//  Created by Haeun Chung on 29/03/2018.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import RxSwift
import CRToast
import SVProgressHUD

extension ChannelIO {
  internal class func prepare() {
    if let subscriber = ChannelIO.subscriber {
      mainStore.unsubscribe(subscriber)
    }
    
    let toastOptions:[AnyHashable: Any] = [
      kCRToastNotificationPresentationTypeKey: CRToastPresentationType.cover.rawValue,
      kCRToastNotificationTypeKey: CRToastType.navigationBar.rawValue,
      kCRToastAnimationInDirectionKey: CRToastAnimationDirection.top.rawValue,
      kCRToastAnimationOutDirectionKey: CRToastAnimationDirection.top.rawValue,
      kCRToastBackgroundColorKey: CHColors.yellow,
      kCRToastTextColorKey: UIColor.white,
      kCRToastFontKey: UIFont.boldSystemFont(ofSize: 13)
    ]
    
    ChannelIO.shutdown()
    ChannelIO.initWebsocket()
    
    let subscriber = CHPluginSubscriber()
    mainStore.subscribe(subscriber)
    ChannelIO.subscriber = subscriber
    
    CRToastManager.setDefaultOptions(toastOptions)
    SVProgressHUD.setDefaultStyle(.dark)
  }
  
  internal class func track(
    eventName: String,
    eventProperty: [String: Any]?,
    sysProperty: [String: Any]?) {
    if eventName.utf16.count > 30 || eventName == "" {
      return
    }
    
    EventPromise.sendEvent(
      name: eventName,
      properties: eventProperty,
      sysProperties: sysProperty)
      .subscribe(onNext: { (event) in
        dlog("\(eventName) event sent successfully")
      }, onError: { (error) in
        dlog("\(eventName) event failed")
      }).disposed(by: self.disposeBeg)
  }
  
  internal class func checkInChannel(profile: Profile? = nil) -> Observable<Any?> {
    return Observable.create { subscriber in
      guard let settings = ChannelIO.settings else {
        subscriber.onError(CHErrorPool.unknownError)
        return Disposables.create()
      }
      
      guard settings.pluginKey != "" else {
        subscriber.onError(CHErrorPool.pluginKeyError)
        return Disposables.create()
      }
      
      if let userId = settings.userId, userId != "" {
        PrefStore.setCurrentUserId(userId: userId)
      } else {
        PrefStore.clearCurrentUserId()
      }
      
      var params = [String: Any]()
      params["query"] = CHUtils.bootQueryParams()
      if let profile = profile {
        params["body"] = profile.generateParams()
      }
      
//      let params = BootParamBuilder()
//        .with(profile: profile)
//        .with(sysProfile: nil, includeDefault: true)
//        .build()
      
      PluginPromise
        .boot(pluginKey: settings.pluginKey, params: params)
        .subscribe(onNext: { (data) in
          var data = data
          let channel = data["channel"] as! CHChannel
          if channel.shouldBlock && !channel.trial {
            subscriber.onError(CHErrorPool.serviceBlockedError)
            return
          }
          
          data["settings"] = settings
          
          WsService.shared.connect()
          mainStore.dispatch(UpdateCheckinState(payload: .success))
          mainStore.dispatch(CheckInSuccess(payload: data))
        
          ChannelIO.sendDefaultEvent(.boot)
          
          WsService.shared.ready().take(1).subscribe(onNext: { _ in
            subscriber.onNext(data)
            subscriber.onCompleted()
          }).disposed(by: self.disposeBeg)

        }, onError: { error in
          subscriber.onError(error)
        }, onCompleted: {
          dlog("Check in complete")
        }).disposed(by: self.disposeBeg)
      
      return Disposables.create()
    }
  }
  
  internal class func showUserChat(userChatId: String?, animated: Bool = true) {
    guard let topController = CHUtils.getTopController() else {
      return
    }
    
    ChannelIO.sendDefaultEvent(.open)
    mainStore.dispatch(ChatListIsVisible())
    
    if let userChatViewController = topController as? UserChatViewController,
      userChatViewController.userChatId == userChatId {
      //do nothing
    } else if topController is UserChatsViewController {
      let userChatsController = topController as! UserChatsViewController
      userChatsController.goToUserChatId = userChatId
    } else if topController is UserChatViewController {
      topController.navigationController?.popViewController(animated: false, completion: {
        let userChatsController = CHUtils.getTopController() as! UserChatsViewController
        userChatsController.goToUserChatId = userChatId
        //userChatsController.showUserChat(userChatId: userChatId)
      })
    } else {
      let userChatsController = UserChatsViewController()
      userChatsController.showNewChat = userChatId == nil
      userChatsController.shouldHideTable = true
      if let userChatId = userChatId {
        userChatsController.goToUserChatId = userChatId
      }
      
      let controller = MainNavigationController(rootViewController: userChatsController)
      ChannelIO.baseNavigation = controller
      
      topController.present(controller, animated: animated, completion: nil)
    }
  }
  
  internal class func registerPushToken() {
    guard let pushToken = ChannelIO.pushToken else { return }
    
    let channelId = mainStore.state.channel.id
    
    PluginPromise
      .registerPushToken(channelId: channelId, token: pushToken)
      .subscribe(onNext: { (result) in
        dlog("register token success")
      }, onError:{ error in
        dlog("register token failed")
      }).disposed(by: disposeBeg)
  }
  
  internal class func showNotification(pushData: CHPush?) {
    guard let topController = CHUtils.getTopController(), let push = pushData else {
      return
    }
    
    ChannelIO.hideNotification()
    
    let notificationView = ChatNotificationView()
    notificationView.topLayoutGuide = topController.topLayoutGuide
    
    let notificationViewModel = ChatNotificationViewModel(push: push)
    notificationView.configure(notificationViewModel)
    notificationView.insert(on: topController.view, animated: true)
    
    notificationView.signalForClick()
      .subscribe(onNext: { (event) in
        ChannelIO.hideNotification()
        ChannelIO.showUserChat(userChatId: push.userChat?.id)
      }).disposed(by: self.disposeBeg)
    
    notificationView.closeView.signalForClick()
      .subscribe { (event) in
        ChannelIO.hideNotification()
      }.disposed(by: self.disposeBeg)
    
    ChannelIO.chatNotificationView = notificationView

    CHAssets.playPushSound()
    mainStore.dispatch(RemovePush())
  }
  
  internal class func sendDefaultEvent(_ event: CHDefaultEvent, property: [String: Any]? = nil) {
    if ChannelIO.settings?.enabledTrackDefaultEvent == true {
      ChannelIO.track(eventName: event.rawValue, eventProperty: property)
    }
  }
    
  internal class func hideNotification() {
    guard ChannelIO.chatNotificationView != nil else { return }
    
    mainStore.dispatch(RemovePush())
    ChannelIO.chatNotificationView?.remove(animated: true)
    ChannelIO.chatNotificationView = nil
  }
  
  @objc public class func shutdown() {
    ChannelIO.launcherView?.hide(animated: false)
    ChannelIO.close(animated: false)
    ChannelIO.hideNotification()
    
    PluginPromise.unregisterPushToken()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { _ in
        dlog("shutdown success")
        mainStore.dispatch(CheckOutSuccess())
        WsService.shared.disconnect()
      }, onError: { (error) in
        dlog("shutdown fail")
      }).disposed(by: disposeBeg)
  }
}

extension ChannelIO {
  internal class func initWebsocket() {
    NotificationCenter.default.removeObserver(self)
    
    NotificationCenter.default
      .addObserver(
        self,
        selector: #selector(self.disconnectWebsocket),
        name: NSNotification.Name.UIApplicationWillResignActive,
        object: nil)
    
    NotificationCenter.default
      .addObserver(
        self,
        selector: #selector(self.disconnectWebsocket),
        name: NSNotification.Name.UIApplicationWillTerminate,
        object: nil)
    
    NotificationCenter.default
      .addObserver(
        self,
        selector: #selector(self.connectWebsocket),
        name: NSNotification.Name.UIApplicationDidBecomeActive,
        object: nil)
    
    NotificationCenter.default
      .addObserver(
        self,
        selector: #selector(self.appBecomeActive(_:)),
        name: Notification.Name.UIApplicationWillEnterForeground,
        object: nil)
  }
  
  @objc internal class func disconnectWebsocket() {
    WsService.shared.disconnect()
  }
  
  @objc internal class func connectWebsocket() {
    WsService.shared.connect()
  }
  
  @objc internal class func appBecomeActive(_ application: UIApplication) {
    guard self.isValidStatus else { return }
    _ = GuestPromise.getCurrent().subscribe(onNext: { (user) in
      mainStore.dispatch(UpdateGuest(payload: user))
    })
  }
}
