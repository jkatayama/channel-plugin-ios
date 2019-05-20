//
//  ChannelTests.swift
//  CHPlugin
//
//  Created by R3alFr3e on 2/11/17.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Quick
import Nimble

@testable import ChannelIO

class ChannelTests: QuickSpec {
  
  override func spec() {
    beforeEach {
      
    }
    
    describe("Channel object") {
      context("a default creation") {
        it("should contain default values") {
          let channel = CHChannel()
          expect(channel.name).to(equal(""))
          expect(channel.avatarUrl).to(beNil())
          expect(channel.initial).to(equal(""))
          expect(channel.color).to(equal(""))
          expect(channel.country).to(equal(""))
          expect(channel.textColor).to(equal("white"))
          expect(channel.working).to(beTrue())
          expect(channel.workingTime).to(beNil())
        }
      }

      context("setting properties") {
        it("should contain proper values") {
          
        }
      }
      
      context("canUseSDK") {
        it("should return true if all state is valid") {
          
        }
        
        it("should return false if channel is block") {
          
        }
        
        it("should return false if channel is not pro and not trial") {
          
        }
      }
      
      context("canUsePushBot") {
        it("should return true if all state is valid") {
          
        }
        
        it("should return false if channel is block") {
          
        }
        
        it("should return false if channel is not pro and not trial") {
          
        }
      }
      
      context("canUseSupportBot") {
        it("should return true if all state is valid") {
          
        }
        
        it("should return false if channel is block") {
          
        }
        
        it("should return false if channel is not pro and not trial") {
          
        }
      }
      
      context("launcher") {
        it("should hide launcher if away and not working") {
          
        }
      }

      context("allow new message") {
        it("should return false if away option is not active") {
          
        }
      }
      
      context("shouldShowWorkingTime") {
        it("should return true if not working and has working hours") {
          
        }
      }
      
      context("working time") {
        it("should return structure working time dictionary") {

        }
        
        
        it("should provide next operation hour properly") {
          
        }
      }
      
      context("getClosetWorkingTime") {
        it("should return next weekday and hour left") {
          
        }
        
        it("should return nil if away if custom and not working") {
          
        }
        
        it("should return next coming same weekday if next working hour is only available on same weekday") {
          
        }
      }
    }
  }
}
