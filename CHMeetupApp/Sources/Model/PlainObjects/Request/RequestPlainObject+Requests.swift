//
//  RequestPlainObject+Requests.swift
//  CHMeetupApp
//
//  Created by Sam Mejlumyan on 05/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

extension RequestPlainObject: PlainObjectType {

  enum RequestError: String {
    case accessForbidden
    case notFound
    case failedRequest
  }

  init?(json: JSONDictionary) {
    guard
      let code = json["code"] as? Int,
      let answer = json["answer"] as? String
      else { return nil }

    self.code = code
    self.answer = answer

    if let error = json["error"] as? String {
      self.error = RequestError(rawValue: error)
      self.success = false
    } else {
      self.success = true
      self.error = nil
    }
  }
}

extension RequestPlainObject {

  struct Requests {

    static func editProfile(token: String,
                            email: String,
                            phone: String?,
                            company: String?,
                            position: String?) -> Request<RequestPlainObject> {
      var params: [String: String] = [:]

      params[Constants.Keys.token] = token
      params["email"] = email
      params["phone"] = phone ?? ""
      params["company"] = company ?? ""
      params["position"] = position ?? ""
      return Request(query: "user/edit",
                     method: .post,
                     params: params)
    }


    static func giveSpeech(title: String,
                           description: String,
                           userId: Int,
                           token: String) -> Request<RequestPlainObject> {
      var params = Constants.Server.baseParams
      params["title"] = title
      params["description"] = description

      return Request(query: "user/givespeech",
                                         method: .post,
                                         params: params)
    }

    static func registerPush(pushToken: String,
                             userToken: String?) -> Request<RequestPlainObject> {
      var params = Constants.Server.baseParams
      params["push_token"] = pushToken

      return Request(query: "/user/register_push",
                     method: .post,
                     params: params)
    }
  }
}
