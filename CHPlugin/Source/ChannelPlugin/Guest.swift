//
//  Checkin.swift
//  CHPlugin
//
//  Created by Haeun Chung on 17/03/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

@objc
public class Guest : NSObject {
  var id = ""
  var name = ""
  var avatarUrl = ""
  var mobileNumber = ""
  var property = [String:Any]()
  
  @discardableResult
  @objc public func with(name: String) -> Guest {
    self.name = name
    return self
  }
  
  @discardableResult
  @objc public func with(id: String) -> Guest {
    self.id = id
    return self
  }
  
  @discardableResult
  @objc public func with(avatarUrl: String) -> Guest {
    self.avatarUrl = avatarUrl
    return self
  }
  
  @discardableResult
  @objc public func with(mobileNumber: String) -> Guest {
    self.mobileNumber = mobileNumber
    return self
  }
  
  @discardableResult
  @objc public func with(propertyKey:String, value:Any) -> Guest {
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
