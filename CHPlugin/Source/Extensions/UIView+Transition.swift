//
//  UIView+Transition.swift
//  CHPlugin
//
//  Created by Haeun Chung on 14/02/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import UIKit

enum UIViewTransition : Int {
  case TopToBottom
  case BottomToTop
  case LeftToRight
  case RightToLeft
}

extension UIView {
  func show(onView: UIView, animated: Bool) {
    onView.addSubview(self)
    
    if !animated {
      return
    }
    
    self.alpha = 0
    UIView.transition(with: self, duration: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
      self.alpha = 1
    }) { (completed) in
      
    }
  }
  
  func remove(animated: Bool) {
    if !animated {
      self.removeFromSuperview()
      return
    }
    
    UIView.transition(with: self, duration: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
      self.alpha = 0
    }) { (completed) in
      self.removeFromSuperview()
    }
  }
}
