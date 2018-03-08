//
//  UserChatPromise.swift
//  CHPlugin
//
//  Created by Haeun Chung on 06/02/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON
import ObjectMapper

struct UserChatPromise {
  static func getChats(
    since:Int64?=nil,
    limit:Int,
    sortOrder:String,
    showCompleted: Bool = false) -> Observable<[String: Any?]> {
    return Observable.create { subscriber in
      var params = ["query": [
          "limit": limit,
          "sortOrder":sortOrder,
          "sortField": "updatedAt"
        ]
      ]
      if since != nil {
        params["query"]?["since"] = since
      }
      if showCompleted {
        params["query"]?["states"] = ["open","ready","following","resolved","closed"]
      }
      
      Alamofire.request(RestRouter.GetUserChats(params as RestRouter.ParametersType))
        .validate(statusCode: 200..<300)
        .responseJSON(completionHandler: { response in
          switch response.result {
          case .success(let data):
            let json = JSON(data)
            //next, managers, sessions, userChats, messages
            let next = json["next"].int64Value
            let managers = Mapper<CHManager>().mapArray(JSONObject: json["managers"].object)
            let sessions = Mapper<CHSession>().mapArray(JSONObject: json["sessions"].object)
            let userChats = Mapper<CHUserChat>().mapArray(JSONObject: json["userChats"].object)
            let messages = Mapper<CHMessage>().mapArray(JSONObject: json["messages"].object)
            let bots = Mapper<CHBot>().mapArray(JSONObject: json["bots"].object)
            
            subscriber.onNext([
              "next":next,
              "managers": managers,
              "sessions": sessions,
              "userChats": userChats,
              "messages": messages,
              "bots": bots
            ])
            subscriber.onCompleted()
          case .failure(let error):
            subscriber.onError(error)
          }
        })
      return Disposables.create()
    }.subscribeOn(ConcurrentDispatchQueueScheduler(qos:.background))
  }
  
  static func createChat(pluginId: String, timeStamp: Date?) -> Observable<ChatResponse> {
    return Observable.create { subscriber in
      let params = ["query": [
        "welcomedAt": timeStamp?.getMicroseconds() ?? 0
        ]
      ]
      
      Alamofire.request(RestRouter.CreateUserChat(pluginId, params as RestRouter.ParametersType))
        .validate(statusCode: 200..<300)
        .responseJSON(completionHandler: { response in
          switch response.result {
          case .success(let data):
            let json = JSON(data)
            guard let chatResponse = Mapper<ChatResponse>()
              .map(JSONObject: json.object) else {
                subscriber.onError(CHErrorPool.chatResponseParseError)
                break
            }
            subscriber.onNext(chatResponse)
            subscriber.onCompleted()
          case .failure(let error):
            subscriber.onError(error)
          }
        })
      return Disposables.create()
    }
  }
  static func getChat(userChatId: String) -> Observable<ChatResponse> {
    return Observable.create { subscriber in
      Alamofire.request(RestRouter.GetUserChat(userChatId))
        .validate(statusCode: 200..<300)
        .responseJSON(completionHandler: { response in
          switch response.result {
          case .success(let data):
            let json = JSON(data)
            guard let chatResponse = Mapper<ChatResponse>()
              .map(JSONObject: json.object) else {
              subscriber.onError(CHErrorPool.chatResponseParseError)
              break
            }
            
            subscriber.onNext(chatResponse)
            subscriber.onCompleted()
          case .failure(let error):
            subscriber.onError(error)
          }
          
        })
      return Disposables.create()
    }.subscribeOn(ConcurrentDispatchQueueScheduler(qos:.background))
  }
  
  static func done(userChatId: String, rating: String) -> Observable<ChatResponse> {
    return Observable.create { subscriber in
      var params: [String:[String:String]] = [:]
      if rating != "" {
        params = ["query": [
          "review": rating
        ]]
      }
      
      Alamofire.request(RestRouter.DoneUserChat(
          userChatId, params as RestRouter.ParametersType)
        )
        .validate(statusCode: 200..<300)
        .responseJSON { response in
          switch response.result {
          case .success(let data):
            let json = JSON(data)
            guard let chatResponse = Mapper<ChatResponse>()
              .map(JSONObject: json.object) else {
                subscriber.onError(CHErrorPool.chatResponseParseError)
                break
            }
            
            subscriber.onNext(chatResponse)
            subscriber.onCompleted()
          case .failure(let error):
            subscriber.onError(error)
          }
        }
      return Disposables.create()
    }.subscribeOn(ConcurrentDispatchQueueScheduler(qos:.background))
  }
  
  static func remove(userChatId: String) -> Observable<Any?> {
    return Observable.create { subscriber in
      Alamofire.request(RestRouter.RemoveUserChat(userChatId))
        .validate(statusCode: 200..<300)
        .responseJSON { response in
          if response.response?.statusCode == 200 {
            subscriber.onNext(nil)
            subscriber.onCompleted()
          } else {
            subscriber.onError(CHErrorPool.userChatRemoveError)
          }
        }
      return Disposables.create()
      }.subscribeOn(ConcurrentDispatchQueueScheduler(qos:.background))
  }
  
  @available(*, deprecated)
  static func close(userChatId: String) -> Observable<ChatResponse> {
    return Observable.create { subscriber in
      Alamofire.request(RestRouter.CloseUserChat(userChatId))
        .validate(statusCode: 200..<300)
        .responseJSON(completionHandler: { response in
          switch response.result {
          case .success(let data):
            let json = JSON(data)
            guard let chatResponse = Mapper<ChatResponse>()
              .map(JSONObject: json.object) else {
              subscriber.onError(CHErrorPool.chatResponseParseError)
              break
            }
            
            subscriber.onNext(chatResponse)
            subscriber.onCompleted()
          case .failure(let error):
            subscriber.onError(error)
          }
          
        })
      return Disposables.create()
    }.subscribeOn(ConcurrentDispatchQueueScheduler(qos:.background))
  }
  
  static func getMessages(
    userChatId: String,
    since: String,
    limit: Int,
    sortOrder: String) -> Observable<[String: Any]> {
    return Observable.create { subscriber in
      let params = [
        "query": [
          "since": since,
          "limit": limit,
          "sortOrder": sortOrder
        ]
      ]
      
      Alamofire.request(RestRouter.GetMessages(userChatId, params as RestRouter.ParametersType))
        .validate(statusCode: 200..<300)
        .responseJSON(completionHandler: { response in
          switch response.result {
          case .success(let data):
            let json = JSON(data)

            guard let messages: Array<CHMessage> =
              Mapper<CHMessage>().mapArray(JSONObject: json["messages"].object) else {
                subscriber.onError(CHErrorPool.messageParseError)
                break
            }

            guard let managers: Array<CHManager> =
              Mapper<CHManager>().mapArray(JSONObject: json["managers"].object) else {
                subscriber.onError(CHErrorPool.messageParseError)
                break
            }
            
            guard let bots: Array<CHBot> =
              Mapper<CHBot>().mapArray(JSONObject: json["bots"].object) else {
                subscriber.onError(CHErrorPool.messageParseError)
                break
            }
            
            let prev = json["previous"].string ?? ""
            let next = json["next"].string ?? ""
            
            subscriber.onNext([
              "messages": messages,
              "managers": managers,
              "bots": bots,
              "previous": prev,
              "next": next
            ])
            subscriber.onCompleted()
          case .failure(let error):
            subscriber.onError(error)
          }
        })
      return Disposables.create()
      }.subscribeOn(ConcurrentDispatchQueueScheduler(qos:.background))
  }
  
  static func createMessage(
    userChatId: String,
    message: String,
    requestId: String) -> Observable<CHMessage> {
    return Observable.create { subscriber in
      let params = [
        "body": [
          "message": message,
          "requestId": requestId
        ]
      ]
      
      Alamofire.request(RestRouter.CreateMessage(userChatId, params as RestRouter.ParametersType))
        .validate(statusCode: 200..<300)
        .responseJSON(completionHandler: { response in
          switch response.result {
          case .success(let data):
            let json = JSON(data)
            guard let message = Mapper<CHMessage>()
              .map(JSONObject: json["message"].object) else {
              subscriber.onError(CHErrorPool.messageParseError)
              break
            }
            
            subscriber.onNext(message)
            subscriber.onCompleted()
          case .failure(let error):
            subscriber.onError(error)
          }
        })
      return Disposables.create()
    }.subscribeOn(ConcurrentDispatchQueueScheduler(qos:.background))
  }

  static func uploadFile(
    name: String? = nil,
    file: Data,
    requestId: String,
    userChatId: String,
    category: String) -> Observable<CHMessage> {
    //validate category to make sure it can be handled
    return Observable.create { subscriber in
      let params: [String: Any] = [:]
      
      let requestIdData = requestId.data(using: String.Encoding.utf8, allowLossyConversion: false)
      let request = RestRouter.UploadFile(userChatId, params as RestRouter.ParametersType)
      
      let mimeType = CHUtils.nameToExt(name: category)
      
      Alamofire.upload(
        multipartFormData: { formData in
          let fileName = "Channel_Photo_\(Date().fullDateString()).png"
          formData.append(file, withName: "file",
                          fileName: name ?? fileName,
                          mimeType: mimeType)
          formData.append(requestIdData!, withName: "requestId")
        },
        to: (request.urlRequest?.url?.absoluteString)!,
        headers: request.urlRequest?.allHTTPHeaderFields,
        encodingCompletion: { (encodingResult) in
        switch encodingResult {
        case .success(let upload, _, _):
          upload.uploadProgress(closure: { progress in
            dlog("upload progress \(progress.fractionCompleted)")
            guard var message = messageSelector(state: mainStore.state, id: requestId) else { return }
            if (CGFloat(progress.fractionCompleted) - message.progress) > 0.1 && message.progress != 1.0{
              message.progress = CGFloat(progress.fractionCompleted)
              mainStore.dispatch(UpdateMessage(payload: message))
            }
          })
          
          upload.responseData(completionHandler: { (response) in
            switch response.result {
            case .success(let data):
              let json = JSON(data)
              guard let message = Mapper<CHMessage>()
                .map(JSONObject: json["message"].object) else {
                subscriber.onError(CHErrorPool.messageParseError)
                break
              }
              
              subscriber.onNext(message)
              subscriber.onCompleted()
            case .failure(let error):
              subscriber.onError(error)
            }
          })
          break
        case .failure:
          subscriber.onError(CHErrorPool.uploadError)
        }
      })

      return Disposables.create()
    }.subscribeOn(ConcurrentDispatchQueueScheduler(qos:.background))
  }
  
  static func setMessageReadAll(userChatId: String) -> Observable<Any?> {
    return Observable.create { subscriber in
      Alamofire.request(RestRouter.SetMessagesReadAll(userChatId))
        .validate(statusCode: 200..<300)
        .response(completionHandler: { (response) in
          if response.response?.statusCode == 200 {
            subscriber.onNext(nil)
            subscriber.onCompleted()
          } else {
            subscriber.onError(CHErrorPool.readAllError)
          }
        })
      return Disposables.create()
    }.subscribeOn(ConcurrentDispatchQueueScheduler(qos:.background))
  }
}
