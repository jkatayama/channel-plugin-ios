//
//  Checkin.swift
//  CHPlugin
//
//  Created by Haeun Chung on 17/03/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//
import Foundation

import Foundation

import Foundation

@objc
public class Profile : NSObject {
  var userId = ""
  var name = ""
  var avatarUrl = ""
  var mobileNumber = ""
  var property = [String:Any]()
  
  @discardableResult
  @objc public func set(name: String) -> Profile {
    self.name = name
    return self
  }
  
  @discardableResult
  @objc public func set(userId: String) -> Profile {
    self.userId = userId
    return self
  }
  
  @discardableResult
  @objc public func set(avatarUrl: String) -> Profile {
    self.avatarUrl = avatarUrl
    return self
  }
  
  @discardableResult
  @objc public func set(mobileNumber: String) -> Profile {
    self.mobileNumber = mobileNumber
    return self
  }
  
  @discardableResult
  @objc public func set(propertyKey:String, value:Any) -> Profile {
    self.property[propertyKey] = value
    return self
  }
  
  internal func generateParams() -> [String: Any] {
    var params = [String: Any]()
    if self.name != "" {
      params["name"] = self.name
    }
    
    if self.mobileNumber != "" {
      params["mobileNumber"] = self.mobileNumber
    }
    
    if self.avatarUrl != "" {
      params["avatarUrl"] = self.avatarUrl
    }
    
    if self.property.count != 0 {
      params["property"] = self.property
    }
    
    return params
  }
}
