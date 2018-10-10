//
//  BaseNavigationController.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 1. 31..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

  // MARK: Initializing

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    self.setup()
  }

  override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)
  }

  override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
    super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    self.setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup() {
    // Override point
  }
  
}

