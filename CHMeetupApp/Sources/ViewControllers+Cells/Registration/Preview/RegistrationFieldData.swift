//
//  RegistrationFieldData.swift
//  CHMeetupApp
//
//  Created by Maxim Globak on 05.03.17.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation

struct RegistrationFieldData {
  var sections = [RegistrationFieldSection]()
}

struct RegistrationFieldSection {
  var title: String?
  var fields: [RegistrationFieldItem]
}

struct RegistrationFieldItem {
  var uid: String
  var isRequired: Bool
  var name: String
  var type: EventRegFormFieldPlainObject.EventRegFormFieldType
  var fieldAnswers: [RegistrationFieldFieldAnswer]

  init(with eventRegField: EventRegFormFieldPlainObject) {
    self.uid = "\(eventRegField.id)"
    self.isRequired = eventRegField.required
    self.name = eventRegField.name
    self.type = eventRegField.type
    self.fieldAnswers = eventRegField.answers.flatMap(RegistrationFieldFieldAnswer.init)
  }
}

struct RegistrationFieldFieldAnswer {
  var uid: String
  var value: String
  init(with answer: EventRegFormFieldAnswerPlainObject) {
    self.uid = "\(answer.id)"
    self.value = answer.value
  }
}

struct RegistrationFieldAnswer {
  var uid: String
  var fieldId: String
  var userId: String
  var answer: String
}
