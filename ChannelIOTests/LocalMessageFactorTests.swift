//
//  LocalMessageFactorTests.swift
//  CHPlugin
//
//  Created by Haeun Chung on 10/03/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//


import Quick
import Nimble
//import RxSwift
//import ReSwift

@testable import ChannelIO

class LocalMessageFactoryTests: QuickSpec {
  override func spec() {
    
    describe("date divider") {
      context("when it is used among messages with different date") {
        it("should return the modified message with date divider message") {
          //manually separate dates
          var dates = [Date]()
          for i in 0..<5 {
            dates.append(Date.from(year: 2012, month: 12, day: i))
          }
          
          var messages = [CHMessage]()
          
          for i in 0..<5 {
            let message = CHMessage(chatId: "123",
                                    message: "test",
                                    type: .Default,
                                    createdAt: dates[i])
            messages.append(message)
          }
          
          let modifiedMessages = LocalMessageFactory
            .generate(type: .DateDivider, messages: messages)
          
          var dividerCount = 0
          expect(modifiedMessages.count).to(equal(10))
          
          for msg in modifiedMessages {
            if msg.messageType == .DateDivider {
              dividerCount += 1
            }
          }
          
          expect(dividerCount).to(equal(5))
        }
      }
    }

    describe("new alert message") {
      context("when it is used with session readAt between messages") {
        it("should insert alert message") {
          let createdAt = Date()
          var userChat = CHUserChat()
          var session = CHSession()
          session.readAt = Calendar.current.date(byAdding: .second, value: -10, to: createdAt)
          userChat.session = session
          
          let message = CHMessage(chatId: "31231", message: "test", type: .Default, createdAt: createdAt)
          let messages = [ message, message, message, message, message, message]
          let modifiedMessages = LocalMessageFactory.generate(
            type: .NewAlertMessage,
            messages: messages,
            userChat: userChat)
          
          let shouldContain = modifiedMessages.contains(where: { (message) -> Bool in
            message.messageType == .NewAlertMessage
          })
          expect(shouldContain).to(equal(true))
        }
      }
      
      context("when it is used with session readAt at the end of messages") {
        it("should not included in modified messages") {

        }
      }
    }

    
    describe("user message") {
      context("without user chat") {
        it("") {
          let messages = LocalMessageFactory.generate(type: .UserMessage)
          expect(messages.count).to(equal(1))
          
          let closemsg = messages.first!
          expect(closemsg.chatId).to(equal("dummy"))
          expect(closemsg.message).to(equal(""))
          expect(closemsg.messageType).to(equal(MessageType.UserMessage))
        }
      }

      context("with userChat and text") {
        it("") {
          var userChat = CHUserChat()
          userChat.id = "12345"
          let messages = LocalMessageFactory.generate(
            type: .UserMessage,
            messages: [],
            userChat: userChat,
            text: "WHAHAHAH")
          
          expect(messages.count).to(equal(1))
          
          let closemsg = messages.first!
          expect(closemsg.chatId).to(equal("12345"))
          expect(closemsg.message).to(equal("WHAHAHAH"))
          expect(closemsg.messageType).to(equal(MessageType.UserMessage))
        }
      }

    }
    
    describe("welcome message") {
      context("when it is used") {
        it("should return welcome message") {
          let messages = LocalMessageFactory.generate(type: .WelcomeMessage)
          expect(messages.count).to(equal(1))
          
          let closemsg = messages.first!
          expect(closemsg.chatId).to(equal("welcome_dummy"))
          expect(closemsg.messageType).to(equal(MessageType.WelcomeMessage))
          expect(closemsg.id).to(equal("welcome_dummy"))
        }
      }
    }
  }
}
