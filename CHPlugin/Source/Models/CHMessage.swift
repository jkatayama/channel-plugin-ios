//
//  Message.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 1. 18..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift
import DKImagePickerController
import MobileCoreServices

enum SendingState {
  case New, Sent, Failed
}

struct CHMessage: ModelType {
  // ModelType
  var id = ""
  // Message
  var chatType = ""
  var chatId = ""
  var personType = ""
  var personId = ""
  var message: String?
  var requestId: String?
  var botOption: [String: Bool]? = nil
  
  var createdAt: Date

  var readableDate: String {
    let updateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self.createdAt)
    guard let year = updateComponents.year else { return "" }
    guard let month = updateComponents.month else { return "" }
    guard let day = updateComponents.day else { return "" }
    
    return "\(year)-\(month)-\(day)"
  }
  
  var readableCreatedAt: String {
    let updateComponents = NSCalendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self.createdAt)
    let suffix = (updateComponents.hour ?? 0) >= 12 ? "PM" : "AM"
    
    var hours = 0
    if let componentHour = updateComponents.hour {
      hours = componentHour > 12 ? componentHour - 12 : componentHour
    }
    let minutes = updateComponents.minute ?? 0
    return String(format:"%d:%02d %@", hours, minutes, suffix)
  }
  
  var lastMessage: String? {
    if self.file?.isPreviewable == true {
      return CHAssets.localized("ch.notification.upload_image.description")
    } else if self.file != nil {
      return CHAssets.localized("ch.notification.upload_file.description")
    } else if self.log != nil && self.log?.action == "resolve" {
      return CHAssets.localized("ch.review.require.preview")
    }
    return self.message
  }
  
  var isWelcome: Bool {
    if let option = self.botOption, option["welcome"] == true {
      return true
    } else {
      return false
    }
  }

  var file: CHFile?
  var webPage: CHWebPage?
  var log: CHLog?

  // Dependencies
  var entity: CHEntity?

  // Used in only client
  var state: SendingState = .Sent
  var messageType: MessageType = .Default
  
  var userGuideDialogType: DialogType = .None
  var progress: CGFloat = 1
  //var isRemote = true
}

extension CHMessage: Mappable {
  init(chatId: String,
       message: String,
       type: MessageType,
       entity: CHEntity? = nil,
       createdAt:Date? = Date(),
       id: String? = nil,
       dialogType: DialogType = .None) {
    let now = Date()
    let requestId = "\(now.timeIntervalSince1970 * 1000)"
    self.id = id ?? requestId
    self.message = message
    self.requestId = requestId
    self.chatId = chatId
    self.createdAt = createdAt ?? now
    self.messageType = type
    self.entity = entity
    self.personId = entity?.id ?? ""
    self.personType = entity?.kind ?? ""
    self.userGuideDialogType = dialogType
    self.progress = 1
  }
  
  init(chatId: String, guest: CHGuest, message: String) {
    let now = Date()
    let requestId = "\(now.timeIntervalSince1970 * 1000)"
    self.id = requestId
    self.chatType = "UserChat"
    self.chatId = chatId
    self.personType = guest.type
    self.personId = guest.id
    self.message = message
    self.requestId = requestId
    self.createdAt = now
    self.state = .New
    self.messageType = .UserMessage
    self.progress = 1
    //self.isRemote = false
  }
  
  init(chatId: String, guest: CHGuest, asset: DKAsset) {
    self.init(chatId: chatId, guest: guest, message: "")
    self.file = CHFile(imageAsset: asset)
    self.progress = 0
  }
  
  init?(map: Map) {
    self.createdAt = Date()
  }
  
  mutating func mapping(map: Map) {
    id          <- map["id"]
    chatType    <- map["chatType"]
    chatId      <- map["chatId"]
    personType  <- map["personType"]
    personId    <- map["personId"]
    message     <- map["message"]
    requestId   <- map["requestId"]
    file        <- map["file"]
    webPage     <- map["webPage"]
    log         <- map["log"]
    createdAt   <- (map["createdAt"], CustomDateTransform())
    botOption   <- map["botOption"]
    messageType = self.log != nil ? .Log : .Default
  }
}

extension CHMessage {
  func isSameDate(previous: CHMessage?) -> Bool {
    if previous == nil { return true }
    return NSCalendar.current
      .isDate(self.createdAt, inSameDayAs: previous!.createdAt)
  }
  
  func isContinue(previous: CHMessage?) -> Bool {
    if previous == nil { return false }
    
    //check time
    let calendar = NSCalendar.current
    let previousHour = calendar.component(.hour, from: (previous?.createdAt)!)
    let currentHour = calendar.component(.hour, from: self.createdAt)
    let previousMin = calendar.component(.minute, from: (previous?.createdAt)!)
    let currentMin = calendar.component(.minute, from: self.createdAt)
    
    if previousHour == currentHour &&
      previousMin == currentMin &&
      previous?.personId == self.personId &&
      previous?.personType == self.personType &&
      self.personId != "" {
      return true
    }
    
    return false
  }
}

//MARK: RestAPI

extension CHMessage {
  //TODO: refactor async call into actions 
  //but to do that, it also has to handle errors in redux
  static func getMessages(
    userChatId: String,
    since: String,
    limit: Int,
    sortOrder:String) -> Observable<[String: Any]> {
    
    return UserChatPromise.getMessages(
      userChatId: userChatId,
      since: since,
      limit: limit,
      sortOrder: sortOrder)
  }
  
  func isMine() -> Bool {
    let me = mainStore.state.guest
    return self.entity?.id == me.id
  }
  
  func send() -> Observable<CHMessage> {
    if file != nil {
      return self.sendFile()
    } else {
      return self.sendText()
    }
  }
  
  func sendFile() -> Observable<CHMessage> {
    return Observable.create{ subscriber in
      guard let file = self.file, file.rawData != nil || file.asset != nil else {
        subscriber.onError(CHErrorPool.sendFileError)
        return Disposables.create()
      }
      
      var data: Data?
      if let asset = file.asset {
        if file.category == "gif" {
          asset.fetchImageDataForAsset(true, completeBlock: { (rawData, info) in
              data = rawData
          })
        } else if file.category == "image" {
          asset.fetchOriginalImage(true, completeBlock: { (image, info) in
            data = UIImageJPEGRepresentation(image!, 1.0)
          })
        } else {
          //
        }
      } else {
        data = file.rawData
      }
      
      if data == nil {
        subscriber.onError(CHErrorPool.sendFileError)
        return Disposables.create()
      }

      let disposable = UserChatPromise.uploadFile(
        name: nil,
        file: data!,
        requestId: self.requestId!,
        userChatId: self.chatId,
        category: file.category)
        .subscribe(onNext: { (message) in
          subscriber.onNext(message)
        }, onError: { (error) in
          subscriber.onError(error)
        })
      
      return Disposables.create(with: {
        disposable.dispose()
      })
    }
  }
  
  func sendText() -> Observable<CHMessage> {
    return Observable.create { subscriber in
      let disposable = UserChatPromise.createMessage(userChatId: self.chatId,
                                        message: self.message ?? "",
                                        requestId: self.requestId!)
        .subscribe(onNext: { (message) in
          subscriber.onNext(message)
        }, onError: { (error) in
          subscriber.onError(error)
        })
      
      return Disposables.create(with: {
        disposable.dispose()
      })
    }
  }
}

extension CHMessage: Equatable {}

func ==(lhs: CHMessage, rhs: CHMessage) -> Bool {
  return lhs.id == rhs.id &&
    lhs.messageType == rhs.messageType &&
    lhs.userGuideDialogType == rhs.userGuideDialogType &&
    lhs.progress == rhs.progress &&
    lhs.file?.downloaded == rhs.file?.downloaded &&
    lhs.state == rhs.state &&
    lhs.webPage == rhs.webPage
}
