//
//  MessageCellModel.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 9..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import UIKit

enum ClipType {
  case None
  case File
  case Image
  case Webpage
}

protocol MessageCellModelType {
  var name: String { get }
  var timestamp: String { get }
  var timestampIsHidden: Bool { get }
  var message: CHMessage { get }
  var avatarEntity: CHEntity { get }
  var avatarIsHidden: Bool { get }
  var bubbleBackgroundColor: UIColor { get }
  var textColor: UIColor { get }
  var usernameIsHidden: Bool { get }
  var imageIsHidden: Bool { get }
  var fileIsHidden: Bool { get }
  var webpageIsHidden: Bool { get }
  var webpage: CHWebPage? { get }
  var file: CHFile? { get }
  var createdByMe: Bool { get }
  var isContinuous: Bool { get }
  var messageType: MessageType { get }
  var progress: CGFloat { get }
  var isFailed: Bool { get }
  var profileItems: [CHProfileItem] { get set }
  var currentIndex: Int { get set }
  var totalCount: Int { get set }
}

struct MessageCellModel: MessageCellModelType {
  let name: String
  let timestamp: String
  let timestampIsHidden: Bool
  let message: CHMessage
  let avatarEntity: CHEntity
  let avatarIsHidden: Bool
  let bubbleBackgroundColor: UIColor
  let textColor: UIColor
  let usernameIsHidden: Bool
  let imageIsHidden: Bool
  let fileIsHidden: Bool
  let webpageIsHidden: Bool
  let webpage: CHWebPage?
  let file: CHFile?
  let createdByMe: Bool
  let isContinuous: Bool
  let messageType: MessageType
  let progress: CGFloat
  let isFailed: Bool
  
  var profileItems: [CHProfileItem]
  var currentIndex: Int
  var totalCount: Int
  
  init(message: CHMessage, previous: CHMessage?) {
    let channel = mainStore.state.channel
    let plugin = mainStore.state.plugin
    let isContinuous = message.isContinue(previous: previous)
    let clipType = MessageCellModel.getClipType(message: message)
    let createdByMe = message.entity is CHUser || message.entity is CHVeil

    self.name = message.entity?.name ?? ""
    self.timestamp = message.readableCreatedAt
    self.timestampIsHidden = isContinuous
    self.message = message
    self.avatarEntity = message.entity ?? channel
    self.avatarIsHidden = createdByMe || isContinuous
    self.bubbleBackgroundColor = createdByMe ? UIColor(plugin.color)! : CHColors.lightGray
    self.textColor = plugin.textColor == "white" ? CHColors.white : CHColors.black
    self.usernameIsHidden = createdByMe || isContinuous
    self.imageIsHidden = (clipType != ClipType.Image)
    self.fileIsHidden = (clipType != ClipType.File)
    self.webpageIsHidden = (clipType != ClipType.Webpage)
    self.webpage = message.webPage
    self.file = message.file
    self.createdByMe = createdByMe
    self.isContinuous = isContinuous
    
    self.messageType = message.messageType
    self.progress = message.progress
    self.isFailed = message.state == .Failed
    
    self.profileItems = message.profileBot ?? []
    if let index = self.profileItems.index(where: { (profileItem) -> Bool in
      return profileItem.value == nil
    }) {
      self.currentIndex = index
    } else {
      self.currentIndex = self.profileItems.count - 1
    }
    self.totalCount = self.profileItems.count //max 4
  }

  static func getClipType(message: CHMessage) -> ClipType {
    if message.file?.isPreviewable == true || message.file?.asset != nil {
      return .Image
    } else if message.file != nil {
      return .File
    } else if message.webPage != nil {
      return .Webpage
    } else {
      return .None
    }
  }

}
