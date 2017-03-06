//
//  PlainObjectType.swift
//  CHMeetupApp
//
//  Created by Sam on 28/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: Any]

protocol PlainObjectType {
  init?(json: JSONDictionary)
}

extension Array where Element: PlainObjectType {
  init(json: [JSONDictionary]) {
    let value = json.flatMap(Iterator.Element.init)
    self = value
  }
}
