//
//  NavigationButton.swift
//  ch-desk-ios
//
//  Created by Haeun Chung on 15/05/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import UIKit

enum NavigationItemAlign {
  case left
  case right
  case center
}

class NavigationItem: UIBarButtonItem {
  public var actionHandler: (() -> Void)?
  
  convenience init(
    image: UIImage?,
    text: String? = "",
    fitToSize: Bool = false,
    alignment: NavigationItemAlign = .center,
    textColor: UIColor? = UIColor.white,
    actionHandler: (() -> Void)?) {
    
    let button = UIButton(type: .custom)
    button.setImage(image, for: .normal)
    button.setTitle(text, for: .normal)
    button.imageView?.tintColor = textColor
    button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
    button.setTitleColor(textColor, for: .normal)

    self.init(customView: button)
    button.addTarget(self, action: #selector(barButtonItemPressed), for: .touchUpInside)
    self.actionHandler = actionHandler
  }
  
  convenience init(
    title: String?,
    style: UIBarButtonItemStyle,
    textColor: UIColor = CHColors.defaultTint,
    actionHandler: (() -> Void)?) {
    
    self.init(title: title, style: style, target: nil, action: #selector(barButtonItemPressed))
    self.target = self
    self.actionHandler = actionHandler
    self.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:textColor], for: .normal)
    
    let disableColor = textColor.withAlphaComponent(0.3)
    self.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:disableColor], for: .disabled)
  }
  
  convenience init(
    image: UIImage?,
    style: UIBarButtonItemStyle,
    actionHandler: (() -> Void)?) {
    
    self.init(image: image, style: style, target: nil, action: #selector(barButtonItemPressed))
    self.target = self
    self.actionHandler = actionHandler
  }
  
  @objc func barButtonItemPressed(sender: UIBarButtonItem) {
    actionHandler?()
  }
}
