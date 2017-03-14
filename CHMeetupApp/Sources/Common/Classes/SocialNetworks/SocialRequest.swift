//
//  SocialRequestProtocol.swift
//  CHMeetupApp
//
//  Created by Sergey Zapuhlyak on 11/02/2017.
//  Copyright © 2017 Sergey Zapuhlyak. All rights reserved.
//

import Foundation

typealias SuccessHandler = (SocialRequestProtocol) -> Void
typealias FailureHandler = (SocialRequestProtocol, Error?) -> Void

protocol SocialRequestProtocol {
  func serialize() -> [String: Any]
  func httpMethod() -> String
  func methodName() -> String
  func responseClass() -> Swift.AnyClass
}

extension SocialRequestProtocol {
  func buildResponse(_ parameters: [String: Any]) -> AnyObject? {
    if let aClass = self.responseClass() as? SocialResponse.Type {
      let response: SocialResponse = aClass.init()
      response.readDictionary(parameters)
      return response
    }
    return nil
  }
}

class SocialRequest {
  var response: SocialResponse?
  var isResponseJSON = true
  var success: SuccessHandler?
  var failure: FailureHandler?
}
