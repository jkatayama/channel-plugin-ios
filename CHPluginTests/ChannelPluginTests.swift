//
//  CHPluginTests.swift
//  CHPluginTests
//
//  Created by 이수완 on 2017. 1. 9..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Quick
import Nimble
import CHPlugin

class CHPluginTests: QuickSpec {

  override func spec() {
    describe("CHPlugin") {
      it("works") {
        expect(ChannelPlugin().test()).to(beTrue())
      }
    }
  }

}
