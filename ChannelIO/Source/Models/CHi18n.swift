//
//  CHi18n.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 6..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Foundation
import ObjectMapper

struct CHi18n {
  var text: String = ""
  var en: String?
  var ja: String?
  var ko: String?

  func getAttributedMessage(with config: CHMessageParserConfig? = nil) -> NSAttributedString? {
    let key = CHUtils.getLocale()
    var i18nText: String? = nil
    if key == .english {
      i18nText = en ?? text
    } else if key == .japanese {
      i18nText = ja ?? text
    } else if key == .korean {
      i18nText = ko ?? text
    }
    
    let config = config ?? CHMessageParserConfig(font: UIFont.systemFont(ofSize: 14))
    let transformer = CustomBlockTransform(config: config)
    if let i18nText = i18nText {
      return transformer.parser.parseText(i18nText)
    }
    return nil
  }
  
  func getMessageBlock() -> CHMessageBlock? {
    let key = CHUtils.getLocale()
    var i18nText: String? = nil
    if key == .english {
      i18nText = en ?? text
    } else if key == .japanese {
      i18nText = ja ?? text
    } else if key == .korean {
      i18nText = ko ?? text
    }
    return CHMessageBlock(type: .text, value: i18nText)
  }
}

extension CHi18n: Mappable {
  init?(map: Map) { }
  
  mutating func mapping(map: Map) {
    text    <- map ["text"]
    en      <- map["en"]
    ja      <- map["ja"]
    ko      <- map["ko"]
  }
}

extension CHi18n: Equatable {}

func ==(lhs: CHi18n, rhs: CHi18n) -> Bool {
  return lhs.text == rhs.text
    && lhs.ko == rhs.ko
    && lhs.ja == rhs.ja
    && lhs.en == rhs.en
}
