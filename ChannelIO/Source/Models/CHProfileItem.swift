//
//  CHProfileBot.swift
//  ChannelIO
//
//  Created by R3alFr3e on 4/16/18.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import UIKit
import ObjectMapper

struct CHProfileItem {
  var id            : String = ""
  var key           : String = ""
  var type          : String = ""
  var nameI18n      : CHi18n? = nil
  var value         : Any? = nil
  
  var isCompleted   : Bool = false
}

extension CHProfileItem: Mappable {
  init?(map: Map) { }
  
  mutating func mapping(map: Map) {
    id        <- map["id"]
    key       <- map["key"]
    type      <- map["type"]
    nameI18n  <- map["nameI18n"]
    value     <- map["value"]
  }
}
