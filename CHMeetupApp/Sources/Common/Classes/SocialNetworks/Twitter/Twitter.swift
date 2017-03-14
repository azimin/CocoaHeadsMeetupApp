//
//  Twitter.swift
//  CHMeetupApp
//
//  Created by Sergey Zapuhlyak on 06/03/2017.
//  Copyright © 2017 Sergey Zapuhlyak. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

public typealias TokenSuccessHandler = (Credential.OAuthAccessToken?) -> Void

class Twitter: SocialNetwork {

  struct OAuth {
    static let version = "1.0"
    static let signatureMethod = "HMAC-SHA1"
    static let url = "https://api.twitter.com"
  }

  var consumerKey: String
  var consumerSecret: String

  var credential: Credential?

  let dataEncoding: String.Encoding = .utf8

  init(consumerKey: String, consumerSecret: String) {
    self.consumerKey = consumerKey
    self.consumerSecret = consumerSecret
  }

  init(consumerKey: String, consumerSecret: String, accessToken: String, accessTokenSecret: String) {
    self.consumerKey = consumerKey
    self.consumerSecret = consumerSecret

    let credentialAccessToken = Credential.OAuthAccessToken(key: accessToken, secret: accessTokenSecret)
    self.credential = Credential(accessToken: credentialAccessToken)
  }

  func authorize(with callbackURL: URL, presentFrom presentingViewController: UIViewController?,
                 success: TokenSuccessHandler?, failure: FailureHandler? = nil) {

    self.postOAuthRequestToken(with: callbackURL, success: { token in
      var requestToken = token!

      NotificationCenter.default.addObserver(forName: .CloseSafariViewControllerNotification,
                                             object: nil, queue: .main) { notification in
        NotificationCenter.default.removeObserver(self)
        presentingViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
        if let url = notification.object as? URL {
          let parameters = url.query!.queryStringParameters
          requestToken.verifier = parameters["oauth_verifier"]
          self.postOAuthAccessToken(with: requestToken, success: { accessToken in
            self.credential = Credential(accessToken: accessToken!)
            success?(accessToken!)
          }, failure: failure)
        }
      }
      let baseURL = URL(string: OAuth.url)
      let authorizeURL = URL(string: "oauth/authorize", relativeTo: baseURL)
      let queryURL = URL(string: authorizeURL!.absoluteString + "?oauth_token=\(token!.key)")!
      if let delegate = presentingViewController as? AuthViewController {
        delegate.showSafariViewController(url: queryURL)
      }
    }, failure: failure)
  }

  func postOAuthRequestToken(with callbackURL: URL, success: @escaping TokenSuccessHandler, failure: FailureHandler?) {

    let req = TwitterOAuthRequestTokenRequest()
    req.oauthCallback = callbackURL.absoluteString
    req.success = { request in
      if let response = (request as? SocialRequest)?.response as? TwitterOAuthRequestTokenResponse {
        guard let key = response.key,
          let secret = response.secret else {
          return
        }
        let accessToken = Credential.OAuthAccessToken(key: key, secret: secret)
        success(accessToken)
      }
    }
    req.failure = failure
    sendRequest(req)
  }

  func postOAuthAccessToken(with requestToken: Credential.OAuthAccessToken,
                            success: @escaping TokenSuccessHandler, failure: FailureHandler?) {
    let req = TwitterOAuthAccessTokenRequest()
    if let verifier = requestToken.verifier {
      req.oauthToken = requestToken.key
      req.oauthVerifier = verifier
      req.success = { request in
        if let response = (request as? SocialRequest)?.response as? TwitterOAuthAccessTokenResponse {
          guard let key = response.key,
            let secret = response.secret,
            let screenName = response.screenName,
            let userID = response.userID else {
              return
          }
          let accessToken = Credential.OAuthAccessToken(key: key, secret: secret,
                                                        screenName: screenName, userID: userID)
          success(accessToken)
        }
      }
      req.failure = failure
      sendRequest(req)
    } else {
      // TODO: Make Error with string "Bad OAuth response received from server"
      // and call this closure
      // failure?(req, error)
    }
  }

  public func urlRequest<T: SocialRequestProtocol>(by request: T) -> URLRequest where T: SocialRequest {
    let httpMethod = request.httpMethod()
    let methodName = request.methodName()
    let parameters = request.serialize()
    let baseURL = NSURL(string: OAuth.url)

    let urlRequest = requestWithMethod(httpMethod, path: methodName, parameters: parameters, baseURL: baseURL!)

    return urlRequest
  }

  public func sendRequest<T: SocialRequestProtocol>(_ request: T) where T: SocialRequest {

    let urlRequest = self.urlRequest(by: request)

    sendRequest(request, urlRequest: urlRequest)
  }

  override func requestWithMethod(_ method: String, path: String,
                                  parameters: [String: Any], baseURL: NSURL) -> URLRequest {

    let nonOAuthParameters = parameters.filter { key, _ in !key.hasPrefix("oauth_") }
    var request = super.requestWithMethod(method, path: path, parameters: nonOAuthParameters, baseURL: baseURL)
    request.setValue(self.authorizationHeader(for: method, url: request.url!,
                                              parameters: parameters, isMediaUpload: false),
                     forHTTPHeaderField: "Authorization")
    request.httpShouldHandleCookies = false

    return request
  }

  func authorizationHeader(for method: String, url: URL, parameters: [String: Any], isMediaUpload: Bool) -> String {
    var authorizationParameters = [String: Any]()
    authorizationParameters["oauth_version"] = OAuth.version
    authorizationParameters["oauth_signature_method"] =  OAuth.signatureMethod
    authorizationParameters["oauth_consumer_key"] = self.consumerKey
    authorizationParameters["oauth_timestamp"] = String(Int(Date().timeIntervalSince1970))
    authorizationParameters["oauth_nonce"] = UUID().uuidString
    authorizationParameters["oauth_token"] ??= self.credential?.accessToken?.key

    for (key, value) in parameters where key.hasPrefix("oauth_") {
      authorizationParameters.updateValue(value, forKey: key)
    }

    let combinedParameters = authorizationParameters +| parameters

    let finalParameters = isMediaUpload ? authorizationParameters : combinedParameters

    authorizationParameters["oauth_signature"] = self.oauthSignature(for: method, url: url,
                                                                     parameters: finalParameters,
                                                                     accessToken: self.credential?.accessToken)

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
                      accessToken token: Credential.OAuthAccessToken?) -> String {
    let tokenSecret = token?.secret.urlEncodedString() ?? ""
    let encodedConsumerSecret = self.consumerSecret.urlEncodedString()
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
