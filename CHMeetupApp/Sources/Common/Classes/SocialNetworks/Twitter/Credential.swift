//
//  TwitterCredential.swift
//  CHMeetupApp
//
//  Created by Sergey Zapuhlyak on 09/03/2017.
//  Copyright © 2017 Sergey Zapuhlyak. All rights reserved.
//

import Foundation

public class Credential {

  public struct OAuthAccessToken {

    public internal(set) var key: String
    public internal(set) var secret: String
    public internal(set) var verifier: String?

    public internal(set) var screenName: String?
    public internal(set) var userID: String?

    public init(key: String, secret: String) {
      self.key = key
      self.secret = secret
    }

    public init(key: String, secret: String, screenName: String, userID: String) {
      self.key = key
      self.secret = secret

      self.screenName = screenName
      self.userID = userID
    }
  }

  public internal(set) var accessToken: OAuthAccessToken?

  public init(accessToken: OAuthAccessToken) {
    self.accessToken = accessToken
  }
}
