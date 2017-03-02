//
//  Request.swift
//  CHMeetupApp
//
//  Created by Sam on 28/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation

typealias RequestParams = [String: String]

enum RequestMethod: String {
  case get
  case post
  case head
  case delete

  var `string`: String {
    return self.rawValue.uppercased()
  }
}

struct Request<T> {

  let query: String
  let params: RequestParams?
  let method: RequestMethod

  let parser: RequestContentParser<T>?

  let contentType = T.Type.self

  init(query: String,
       method: RequestMethod = .get,
       params: RequestParams? = nil,
       parser: RequestContentParser<T>? = nil) {
    self.query = query
    self.params = params
    self.method = method
    self.parser = parser
  }

}
