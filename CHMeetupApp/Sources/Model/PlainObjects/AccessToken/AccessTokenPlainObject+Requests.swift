//
//  AccessTokenPlainObject+Requests.swift
//  CHMeetupApp
//
//  Created by Sergey Zapuhlyak on 16/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

extension AccessTokenPlainObject: PlainObjectType {

  struct Requests {
    static func requestToken(callback: String) -> Request<AccessTokenPlainObject> {
      let params = ["oauth_callback": callback]
      return Request(query: "oauth/request_token", method: .post, params: params)
    }
  }

  init?(json: JSONDictionary) {
    guard
      let key = json["oauth_token"] as? String,
      let secret = json["oauth_token_secret"] as? String
      else { return nil }

    self.key = key
    self.secret = secret
    self.verifier = nil
    self.screenName = nil
    self.userID = nil
  }
}
