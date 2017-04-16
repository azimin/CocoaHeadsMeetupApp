//
//  EventRegFormFieldPlainObject.swift
//  CHMeetupApp
//
//  Created by Sam Mejlumyan on 07/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

enum EventRegFormFieldAnswer {
  case string(value: String)
  case selection(isSelected: Bool)

  func parseAnswers() -> (Bool, String) {
    switch self {
    case let .selection(isSelected):
      return (isSelected, "")
    case let .string(value):
      return (false, value)
    }
  }
}

enum EventRegFormFieldType: String {
  case string
  case checkbox
  case radio

  func parse(answer: Any?) -> Any {
    switch self {
    case .string:
      return (answer as? String) ?? ""
    case .checkbox, .radio:
      if let result = answer as? Bool, result == true {
        return true
      }
      return false
    }
  }
}

struct EventRegFormFieldPlainObject {
  let id: Int
  let required: Bool
  let name: String
  let type: EventRegFormFieldType
  let answers: [EventRegFormFieldAnswerPlainObject]
}

extension EventRegFormFieldPlainObject: PlainObjectType {

  init?(json: JSONDictionary) {

    guard
      let id = json["field_id"] as? Int,
      let required = json["required"] as? Bool,
      let field = json["field"] as? JSONDictionary,
      let name = field["name"] as? String,
      let fieldTypeString = field["type"] as? String,
      let fieldType = EventRegFormFieldType(rawValue: fieldTypeString),
      let fieldAnswers = field["field_answers"] as? [JSONDictionary]
    else { return nil }

    self.id = id
    self.required = required
    self.name = name
    type = fieldType
    answers = fieldAnswers.flatMap(EventRegFormFieldAnswerPlainObject.init)
  }
}
