//
//  TwitterOAuthRequestToken.swift
//  CHMeetupApp
//
//  Created by Sergey Zapuhlyak on 06/03/2017.
//  Copyright © 2017 Sergey Zapuhlyak. All rights reserved.
//

import Foundation

class TwitterOAuthRequestTokenRequest: SocialRequest, SocialRequestProtocol {
  var oauthCallback: String?

  override init() {
    super.init()
    self.isResponseJSON = false
  }

  func serialize() -> [String: Any] {
    var dict = [String: Any] ()
    dict["oauth_callback"] ??= self.oauthCallback
    return dict
  }

  func httpMethod() -> String {
    return "POST"
  }

  func methodName() -> String {
    return "oauth/request_token"
  }

  func responseClass() -> Swift.AnyClass {
    return TwitterOAuthRequestTokenResponse.self
  }
}

class TwitterOAuthRequestTokenResponse: SocialResponse {
  var key: String?
  var secret: String?

  override func readDictionary(_ dict: [String: Any]) {
    super.readDictionary(dict)
    self.key = dict["oauth_token"] as? String
    self.secret = dict["oauth_token_secret"] as? String
  }
}
