//
//  CHForm.swift
//  ChannelIO
//
//  Created by Haeun Chung on 08/06/2018.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import Foundation
import ObjectMapper

enum ActionOptionKey: String {
  case disableToManager
}

enum ActionType: String {
  case select
  case button
  case solve = "userChat.solve"
  case close = "userChat.close"
  case support = "supportBot"
}

struct CHAction {
  var type: ActionType = .select
  var buttons: [CHActionButton] = []
  var closed: Bool = false
  var option: [ActionOptionKey: Bool] = [:]
  
  static func create(botEntry: CHSupportBotEntryInfo) -> CHAction {
    var action = CHAction()
    action.type = .support
    action.buttons = botEntry.buttons
    
    return action
  }
}

extension CHAction: Mappable {
  init?(map: Map) { }
  
  mutating func mapping(map: Map) {
    type        <- map["type"]
    buttons     <- map["buttons"]
    option      <- map["option"]
    closed      <- map["closed"]
  }
}

struct CHActionButton {
  var id: String = ""
  var key: String = ""
  var text: NSAttributedString? = nil
  
  var onlyEmoji: Bool = false
}

extension CHActionButton: Mappable {
  init?(map: Map) { }
  
  mutating func mapping(map: Map) {
    id          <- map["id"]
    key         <- map["key"]
    let rawText = map["text"].currentValue as? String ?? ""
    (text, onlyEmoji) = CustomMessageTransform.markdown.parse(rawText)
  }
}

struct CHSubmit {
  var id: String = ""
  var key: String = ""
}

extension CHSubmit: Mappable {
  init?(map: Map) { }
  
  mutating func mapping(map: Map) {
    id        <- map["id"]
    key       <- map["key"]
  }
}
