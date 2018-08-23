//
//  Checkin.swift
//  CHPlugin
//
//  Created by Haeun Chung on 17/03/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//
import Foundation

@objc
public class Profile : NSObject {
  var name = ""
  var avatarUrl = ""
  var mobileNumber = ""
  var email = ""
  var property = [String:Any]()
  
  @discardableResult
  @objc public func set(name: String) -> Profile {
    self.name = name
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
  @objc public func set(email: String) -> Profile {
    self.email = email
    return self
  }
  
  @discardableResult
  @objc public func set(propertyKey:String, value:Any) -> Profile {
    self.property[propertyKey] = value
    return self
  }
}
