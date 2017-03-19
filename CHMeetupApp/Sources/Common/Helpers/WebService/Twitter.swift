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

  let dataEncoding: String.Encoding = .utf8
  var accessToken: AccessTokenPlainObject?

  func customSessionRequest<T>(_ request: Request<T>, with url: URL) -> URLRequest {

    var sessionRequest = URLRequest(url: url)

    let method = request.method.string
    sessionRequest.httpMethod = method

    let params = request.params ?? [:]
    let nonOAuthParameters = params.filter { key, _ in !key.hasPrefix("oauth_") }
    if nonOAuthParameters.count != 0 {
      let connector = url.path.range(of: "?") == nil ? "?" : "&"
      let path = url.absoluteString + connector + nonOAuthParameters.queryString
      sessionRequest.url = URL(string: path)?.absoluteURL
    }

    let header = self.authorizationHeader(for: method, url: url, params: params, isMediaUpload: false)
    sessionRequest.setValue(header, forHTTPHeaderField: "Authorization")
    sessionRequest.httpShouldHandleCookies = false
    
    return sessionRequest
  }

  func authorizationHeader(for method: String, url: URL, params: RequestParams, isMediaUpload: Bool) -> String {
    var authorizationParameters = [String: Any]()
    authorizationParameters["oauth_version"] = Constants.Twitter.versionOAuth
    authorizationParameters["oauth_signature_method"] =  Constants.Twitter.signatureMethod
    authorizationParameters["oauth_consumer_key"] = Constants.Twitter.key
    authorizationParameters["oauth_timestamp"] = String(Int(Date().timeIntervalSince1970))
    authorizationParameters["oauth_nonce"] = UUID().uuidString
    authorizationParameters["oauth_token"] ??= self.accessToken?.key

    for (key, value) in params where key.hasPrefix("oauth_") {
      authorizationParameters.updateValue(value, forKey: key)
    }

    let combinedParameters = authorizationParameters +| params

    let finalParameters = isMediaUpload ? authorizationParameters : combinedParameters

    authorizationParameters["oauth_signature"] = self.oauthSignature(for: method, url: url,
                                                                     parameters: finalParameters,
                                                                     accessToken: self.accessToken)

    let encodedParameters = authorizationParameters.urlEncodedQueryString(using: self.dataEncoding)
    let authorizationParameterComponents = encodedParameters.components(separatedBy: "&").sorted()

    var headerComponents = [String]()
    for component in authorizationParameterComponents {
      let subcomponent = component.components(separatedBy: "=")
      if subcomponent.count == 2 {
        headerComponents.append("\(subcomponent[0])=\"\(subcomponent[1])\"")
      }
    }

    return "OAuth " + headerComponents.joined(separator: ", ")
  }

  func oauthSignature(for method: String, url: URL, parameters: [String: Any],
                      accessToken token: AccessTokenPlainObject?) -> String {
    let tokenSecret = token?.secret.urlEncodedString() ?? ""
    let encodedConsumerSecret = Constants.Twitter.secret.urlEncodedString()
    let signingKey = "\(encodedConsumerSecret)&\(tokenSecret)"
    let encodedParameters = parameters.urlEncodedQueryString(using: dataEncoding)
    let parameterComponents = encodedParameters.components(separatedBy: "&").sorted()
    let parameterString = parameterComponents.joined(separator: "&")
    let encodedParameterString = parameterString.urlEncodedString()
    let encodedURL = url.absoluteString.urlEncodedString()
    let signatureBaseString = "\(method)&\(encodedURL)&\(encodedParameterString)"

    let key = signingKey.data(using: .utf8)!
    let msg = signatureBaseString.data(using: .utf8)!
    let sha1 = HMAC.sha1(key: key, message: msg)!
    return sha1.base64EncodedString(options: [])
  }
}
