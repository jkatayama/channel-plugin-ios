//
//  Alamofire+Extensions.swift
//  ChannelIO
//
//  Created by Haeun Chung on 18/10/2018.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import Foundation
import Alamofire

extension DataRequest {
  
  /// Adds a handler to be called once the request has finished.
  ///
  /// - parameter options:           The JSON serialization reading options. Defaults to `.allowFragments`.
  /// - parameter completionHandler: A closure to be executed once the request has finished.
  ///
  /// - returns: The request.
  @discardableResult
  public func asyncResponse(
    queue: DispatchQueue? = nil,
    options: JSONSerialization.ReadingOptions = .allowFragments,
    completionHandler: @escaping (AFDataResponse<Data>) -> Void) -> Self {
    return response(
      queue: queue == nil ? RestRouter.queue : queue!,
      responseSerializer: DataResponseSerializer(),
      completionHandler: completionHandler
    )
  }
}



