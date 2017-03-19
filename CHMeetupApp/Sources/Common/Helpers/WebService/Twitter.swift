//
//  Twitter.swift
//  CHMeetupApp
//
//  Created by Sergey Zapuhlyak on 18/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

class Twitter: Server, CustomizableRequest {

  static var oauth: Twitter {
    return Twitter(apiBase: Constants.Twitter.apiBaseOAuth)
  }

  func customSessionRequest<T>(_ request: Request<T>, with url: URL) -> URLRequest {

    var sessionRequest = URLRequest(url: url)

    let method = request.method.string
    sessionRequest.httpMethod = method
    if let params = request.params {
      var nonOAuthParameters = RequestParams()
      _ = params.filter { (key, value) -> Bool in
        if !key.hasPrefix("oauth_") {
          nonOAuthParameters[key] = value
        }
        return true
      }
      sessionRequest.httpBody = nonOAuthParameters.httpQuery
    }

    let header = self.authorizationHeader(for: method, url: url, params: request.params, isMediaUpload: false)
    sessionRequest.setValue(header, forHTTPHeaderField: "Authorization")

    return sessionRequest
  }

  func authorizationHeader(for method: String, url: URL, params: RequestParams?, isMediaUpload: Bool) -> String {
    return ""
  }
}
