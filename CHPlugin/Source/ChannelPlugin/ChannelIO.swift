//
//  ChannelIO.swift
//  ChannelIO
//
//  Created by intoxicated on 2017. 1. 10..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Foundation
import CGFloatLiteral
import ManualLayout
import Reusable
import SnapKit
import Then
import ReSwift
import RxSwift
import UIColor_Hex_Swift
import UserNotifications
import SVProgressHUD
import CRToast
import AVFoundation

let mainStore = Store<AppState>(
  reducer: appReducer,
  state: nil,
  middleware: [loggingMiddleware]
)

func dlog(_ str: String) {
  guard ChannelIO.settings?.debugMode == true else { return }
  print("[CHPlugin]: \(str)")
}

@objc
public protocol ChannelIODelegate: class {
  @objc optional func onChangeBadge(count: Int) -> Void /* notify badge count when changed */
  @objc optional func onClickChatLink(url: URL) -> Bool /* notifiy if a link is clicked */
  @objc optional func willShowChatList() -> Void /* notify when chat list is about to show */
  @objc optional func willHideChatList() -> Void /* notify when chat list is about to hide */
  
  @objc optional func onReceivePush(event: PushEvent) -> Void
}

@objc
public final class ChannelIO: NSObject {
  //MARK: Properties
  @objc public static weak var delegate: ChannelIODelegate? = nil
  
  internal static var launchView : LaunchView?
  internal static var chatNotificationView: ChatNotificationView?
  internal static var baseNavigation: BaseNavigationController?
  internal static var subscriber : CHPluginSubscriber?

  internal static var disposeBeg = DisposeBag()
  internal static var pushToken: String?
  internal static var currentAlertCount = 0

  static var isValidStatus: Bool {
    return mainStore.state.checkinState.status == .success
  }

  internal static var settings: ChannelPluginSettings? = nil
  internal static var guest: Guest? = nil
  

  // MARK: StoreSubscriber
  class CHPluginSubscriber : StoreSubscriber {
    func newState(state: AppState) {
      self.handleBadgeDelegate(state.guest.alert)
      if let launchView = ChannelIO.launchView {
        let viewModel = LaunchViewModel(
          plugin: state.plugin, guest: state.guest
        )
        launchView.configure(viewModel)
      }
      
      self.handlePush(push: state.push)
    }
    
    func handlePush (push: CHPush?) {
      if ChannelIO.baseNavigation == nil && ChannelIO.settings?.hideDefaultInAppPush == false {
        ChannelIO.showNotification(pushData: push)
      }
      if let push = push {
        ChannelIO.delegate?.onReceivePush?(event: PushEvent(with: push))
      }
    }
    
    func handleBadgeDelegate(_ count: Int) {
      if ChannelIO.currentAlertCount != count {
        ChannelIO.delegate?.onChangeBadge?(count: count)
      }
      ChannelIO.currentAlertCount = count
    }
  }
  
  // MARK: Public

  /**
   *   Boot ChannelIO
   *
   *   Boot up ChannelIO and make it ready to use
   *
   *   - parameter settings: ChannelPluginSettings object
   *   - parameter guest: Guest object
   *   - parameter compeltion: ChannelPluginCompletionStatus indicating status of boot phase
   */
  @objc public class func boot(
    with settings: ChannelPluginSettings,
    guest: Guest? = nil,
    completion: ((ChannelPluginCompletionStatus) -> Void)? = nil) {
    
    ChannelIO.prepare()
    ChannelIO.settings = settings
    ChannelIO.guest = guest
    
    if settings.pluginKey == "" {
      mainStore.dispatch(UpdateCheckinState(payload: .notInitialized))
      completion?(.notInitialized)
      return
    }
    
    let topController = CHUtils.getTopController()
    
    PluginPromise.checkVersion().flatMap { (event) in
      return ChannelIO.checkInChannel(guest: guest)
    }
    .subscribe(onNext: { (_) in
      mainStore.dispatch(UpdateCheckinState(payload: .success))
      completion?(.success)
      
      if !settings.hideDefaultLauncher &&
        !mainStore.state.plugin.mobileHideButton &&
        (mainStore.state.channel.shouldShowDefaultLauncher) {
        ChannelIO.showLauncher(on: topController?.view, animated: true)
      }
      
      ChannelIO.fetchScripts()
      ChannelIO.registerPushToken()
      
    }, onError: { error in
      let code = (error as NSError).code
      if code == -1001 {
        dlog("network timeout")
        mainStore.dispatch(UpdateCheckinState(payload: .networkTimeout))
        completion?(.networkTimeout)
      } else if code == CHErrorCode.versionError.rawValue {
        dlog("version is not compatiable. please update sdk version")
        mainStore.dispatch(UpdateCheckinState(payload: .notAvailableVersion))
        completion?(.notAvailableVersion)
      } else if code == CHErrorCode.serviceBlockedError.rawValue {
        dlog("require payment. free plan is not eligible to use SDK")
        mainStore.dispatch(UpdateCheckinState(payload: .requirePayment))
        completion?(.requirePayment)
      } else {
        dlog("unknown")
        mainStore.dispatch(UpdateCheckinState(payload: .unknown))
        completion?(.unknown)
      }
    }).disposed(by: disposeBeg)
  }

  /**
   *   Init a push token.
   *   This method has to be called within
   *   `application:didRegisterForRemoteNotificationsWithDeviceToken:`
   *   in `AppDelegate` in order to get receive push notification from Channel io
   *
   *   - parameter deviceToken: a Data that represents device token
   */
  @objc public class func initPushToken(deviceToken: Data) {
    guard ChannelIO.isValidStatus else { return }
    
    let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    ChannelIO.pushToken = token
  }

  /**
   *   Shutdown ChannelIO
   *   Call this method when user terminate session or logout
   */
  @objc public class func shutdown() {
    ChannelIO.hide(animated: false)
    ChannelIO.close(animated: false)
    ChannelIO.hideNotification()
    
    PluginPromise.unregisterPushToken()
      .subscribe(onNext: { _ in
        dlog("Checkout success")
      }, onError: { (error) in
        
      }).disposed(by: disposeBeg)
    
    WsService.shared.disconnect()
    mainStore.dispatch(CheckOutSuccess())
  }
  
  /**
   *   Show channel launcher on application
   *   location of the view can be customized in Channel Desk
   *
   *   - parameter animated: if true, the view is being added to the window using an animation
   */
  @objc public class func show(animated: Bool) {
    guard ChannelIO.isValidStatus else { return }
    guard let topController = CHUtils.getTopController() else { return }
    
    ChannelIO.showLauncher(on: topController.view, animated: animated)
  }
  
  /**
   *   Show channel launcher on a specific view
   *
   *   - parameter on: view where laucher will be displayed
   *   - parameter animated: if true, the view is being added to the window using an animation
   */
  internal class func showLauncher(on view:UIView?, animated: Bool) {
    guard let view = view else { return }
    guard ChannelIO.isValidStatus else { return }
    
    ChannelIO.hide(animated: false)
    
    let launchView = LaunchView()
    if #available(iOS 11.0, *) {
      launchView.layoutGuide = view.safeAreaLayoutGuide
    }
    
    let viewModel = LaunchViewModel(
      plugin: mainStore.state.plugin, guest: mainStore.state.guest
    )
    
    launchView.show(onView: view, animated: animated)
    launchView.configure(viewModel)
    
    launchView.buttonView.signalForClick()
      .subscribe(onNext: { _ in
        ChannelIO.open(animated: true)
      }).disposed(by: disposeBeg)
    
    ChannelIO.launchView = launchView
  }
  
  /**
   *  Hide channel launcher from application
   *
   *  - parameter animated: if true, the view is being added to the window using an animation
   */
  @objc public class func hide(animated: Bool) {
    guard ChannelIO.isValidStatus else { return }
    guard (ChannelIO.launchView != nil) else { return }
    
    ChannelIO.launchView?.remove(animated: animated)
    ChannelIO.launchView = nil
  }
  
  /** 
   *   Open channel messenger on application
   *
   *   - parameter animated: if true, the view is being added to the window using an animation
   */
  @objc public class func open(animated: Bool) {
    guard ChannelIO.isValidStatus else { return }
    guard !mainStore.state.uiState.isChannelVisible else { return }
    guard let topController = CHUtils.getTopController() else { return }
    
    ChannelIO.delegate?.willShowChatList?()
    mainStore.dispatch(ChatListIsVisible())

    let userChatsController = UserChatsViewController()
    let controller = MainNavigationController(rootViewController: userChatsController)
    ChannelIO.baseNavigation = controller
  
    topController.present(controller, animated: animated, completion: nil)
  }

  /**
   *   Close channel messenger from application
   *
   *   - parameter animated: if true, the view is being added to the window using an animation
   */
  @objc public class func close(animated: Bool) {
    guard ChannelIO.isValidStatus else { return }
    guard ChannelIO.baseNavigation != nil else { return }
    
    ChannelIO.delegate?.willHideChatList?()
    ChannelIO.baseNavigation?.dismiss(
      animated: animated, completion: {
      mainStore.dispatch(ChatListIsHidden())

      ChannelIO.baseNavigation?.removeFromParentViewController()
      ChannelIO.baseNavigation = nil
    })
  }
  
  /**
   *  Open a user chat with given chat id
   *
   *  - parameter chatId: a String user chat id. Will open new chat if chat id is invalid
   *  - parameter completion: a closure to signal completion state
   */
  @objc public class func openChat(with chatId: String? = nil, completion: ((Bool) -> Void)? = nil) {
    guard ChannelIO.isValidStatus else {
      completion?(false)
      return
    }
    
    ChannelIO.showUserChat(userChatId: chatId)
    completion?(true)
  }
  
  /**
   *  Track an event
   *
   *   - parameter eventName: Event name
   *   - parameter eventProperty: a Dictionary contains information about event
   */
  @objc public class func track(eventName: String, eventProperty: [String: Any]? = nil) {
    guard ChannelIO.isValidStatus else { return }
    guard let settings = ChannelIO.settings else { return }
    
    let version = Bundle(for: ChannelIO.self)
      .infoDictionary?["CFBundleShortVersionString"] as! String
    
    ChannelIO.track(eventName: eventName, eventProperty: eventProperty, sysProperty: [
      "pluginId": settings.pluginKey,
      "pluginVersion": version,
      "device": UIDevice.current.modelName,
      "os": "\(UIDevice.current.systemName)_\(UIDevice.current.systemVersion)",
      "screenWidth": UIScreen.main.bounds.width,
      "screenHeight": UIScreen.main.bounds.height,
      "plan": mainStore.state.channel.servicePlan
    ])
  }
  
  /**
   *   Check whether push notification is valid Channel push notification
   *   by inspecting userInfo
   *
   *   - parameter userInfo: a Dictionary contains push information
   */
  @objc public class func isChannelPushNotification(_ userInfo:[AnyHashable: Any]) -> Bool {
    guard let provider = userInfo["provider"] else { return false }
    
    let isCorrectProvider = provider as! String == CHConstants.channelio
    
    let userId = PrefStore.getCurrentUserId() ?? ""
    let veilId = PrefStore.getCurrentVeilId() ?? ""
    let channelId = PrefStore.getCurrentChannelId() ?? ""
    
    let personType = userInfo["personType"] as! String
    let personId = userInfo["personId"] as! String
    let pushChannelId = userInfo["channelId"] as! String
    
    if personType == "User" {
      return personId == userId && pushChannelId == channelId && isCorrectProvider
    }
    
    if personType == "Veil" {
      return personId == veilId && pushChannelId == channelId && isCorrectProvider
    }
    
    return false
  }
  
  /**
   *   Handle push notification for channel
   *   This method has to be called within `userNotificationCenter:response:completionHandler:`
   *   for **iOS 10 and above**, and `application:userInfo:completionHandler:`
   *   for **other version of iOS** in `AppDelegate` in order to make channel
   *   plugin worked properly
   *
   *   - parameter userInfo: a Dictionary contains push information
   */
  @objc public class func handlePushNotification(_ userInfo:[AnyHashable : Any]) {
    guard ChannelIO.isChannelPushNotification(userInfo) else { return }

    //check if checkin 
    if mainStore.state.channel.id != "" {
      let userChatId = userInfo["chatId"] as! String
      ChannelIO.showUserChat(userChatId:userChatId)
      return
    }
    
    let guest = Guest().with(id: PrefStore.getCurrentUserId() ?? "")
    
    ChannelIO.checkInChannel(guest:guest).observeOn(MainScheduler.instance)
      .subscribe(onNext: { (result) in
      let userChatId = userInfo["chatId"] as! String
      ChannelIO.fetchScripts()
      ChannelIO.registerPushToken()
      //not guarantee to be connected here
      ChannelIO.showUserChat(userChatId:userChatId)
    }).disposed(by: disposeBeg)
  }
}
