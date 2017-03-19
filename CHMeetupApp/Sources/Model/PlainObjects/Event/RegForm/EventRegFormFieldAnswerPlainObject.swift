//
//  EventRegFormFieldAnswerPlainObject.swift
//  CHMeetupApp
//
//  Created by Sam Mejlumyan on 07/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

struct EventRegFormFieldAnswerPlainObject {
  let id: Int
  let value: String
}

extension EventRegFormFieldAnswerPlainObject: PlainObjectType {
  init?(json: JSONDictionary) {
    guard
      let id = json["id"] as? Int,
      let value = json["value"] as? String
      else { return nil }

    self.id = id
    self.value = value
  }
}
