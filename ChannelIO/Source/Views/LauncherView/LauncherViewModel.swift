//
//  LauncherViewModel.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 3. 2..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Foundation
import UIKit

protocol LauncherViewModelType {
  var xMargin: CGFloat { get }
  var yMargin: CGFloat { get }
  var bgColor: String { get }
  var borderColor: String { get }
  var badge: Int { get }
  var iconColor: UIColor { get }
  var position: LauncherPosition { get }
}

struct LauncherViewModel: LauncherViewModelType {
  var xMargin = 24.f
  var yMargin = 24.f
  var bgColor = "#00A6FF"
  var borderColor = ""
  var badge = 0
  var iconColor = UIColor.white
  var position = LauncherPosition.right
  
  init(plugin: CHPlugin, guest: CHGuest? = nil, config: LauncherConfig? = nil) {
    if let config = config {
      self.position = config.position
      self.xMargin = CGFloat(config.xMargin)
      self.yMargin = CGFloat(config.yMargin)
    } else {
      self.position = .right
      self.xMargin = 30
      self.yMargin = 30
    }
 
    self.bgColor = plugin.color
    self.borderColor = plugin.borderColor
    self.iconColor = (plugin.textColor == "white") ? UIColor.white : UIColor.black
    self.badge = guest?.alert ?? 0
  }
}
