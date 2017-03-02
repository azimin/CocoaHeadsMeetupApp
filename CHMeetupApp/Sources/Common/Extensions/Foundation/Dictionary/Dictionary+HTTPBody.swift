//
//  Dictionary+HTTPBody.swift
//  CHMeetupApp
//
//  Created by Sam on 25/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation

extension Dictionary where Key: ExpressibleByStringLiteral, Value: ExpressibleByStringLiteral {

  var httpQuery: Data {
    var httpQuery: [String] = []
    self.forEach { (key, value) in
      httpQuery.append(String("\(key)=\(value)"))
    }
    return httpQuery.joined(separator: "&").data(using: .utf8)!
  }

}
