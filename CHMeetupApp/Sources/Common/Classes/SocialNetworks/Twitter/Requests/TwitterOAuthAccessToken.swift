//
//  TwitterOAuthAccessToken.swift
//  CHMeetupApp
//
//  Created by Sergey Zapuhlyak on 10/03/2017.
//  Copyright © 2017 Sergey Zapuhlyak. All rights reserved.
//

import Foundation

class TwitterOAuthAccessTokenRequest: SocialRequest, SocialRequestProtocol {
  var oauthToken: String?
  var oauthVerifier: String?

  override init() {
    super.init()
    self.isResponseJSON = false
  }

  func serialize() -> [String: Any] {
    var dict = [String: Any]()
    dict["oauth_token"] ??= self.oauthToken
    dict["oauth_verifier"] ??= self.oauthVerifier
    return dict
  }

  func httpMethod() -> String {
    return "POST"
  }

  func methodName() -> String {
    return "oauth/access_token"
  }

  func responseClass() -> Swift.AnyClass {
    return TwitterOAuthAccessTokenResponse.self
  }
}

class TwitterOAuthAccessTokenResponse: SocialResponse {
  var key: String?
  var secret: String?
  var screenName: String?
  var userID: String?

  override func readDictionary(_ dict: [String: Any]) {
    super.readDictionary(dict)
    self.key = dict["oauth_token"] as? String
    self.secret = dict["oauth_token_secret"] as? String
    self.screenName = dict["screen_name"] as? String
    self.userID = dict["user_id"] as? String
  }
}
