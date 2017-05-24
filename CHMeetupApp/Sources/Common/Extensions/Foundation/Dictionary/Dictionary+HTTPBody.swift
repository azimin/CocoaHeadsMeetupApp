//
//  Dictionary+HTTPBody.swift
//  CHMeetupApp
//
//  Created by Sam on 25/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

extension Dictionary where Key: ExpressibleByStringLiteral, Value: ExpressibleByStringLiteral {

  var httpQuery: Data {
    var httpQuery: [String] = []
    self.forEach { key, value in
      let keyString = String("\(key)")?.urlEncoding ?? ""
      let valueString = String("\(value)")?.urlEncoding ?? ""

      httpQuery.append(String("\(keyString)=\(valueString)"))
    }
    return httpQuery.joined(separator: "&").data(using: .utf8)!
  }
}
