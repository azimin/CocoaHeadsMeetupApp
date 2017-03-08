//
//  RegistrationFieldData.swift
//  CHMeetupApp
//
//  Created by Maxim Globak on 05.03.17.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation

struct FormData {
  var id: Int
  var name: String
  var sections: [FormFieldItem]

  init(with form: EventRegFormPlainObject) {
    self.id = form.id
    self.name = form.name
    self.sections = form.fields.flatMap(FormFieldItem.init)
  }
}

struct FormFieldItem {
  var id: Int
  var isRequired: Bool
  var name: String
  var type: EventRegFormFieldType
  var fieldAnswers: [FormFieldAnswer]

  init(with field: EventRegFormFieldPlainObject) {
    self.id = field.id
    self.isRequired = field.required
    self.name = field.name
    self.type = field.type
    self.fieldAnswers = field.answers.flatMap { FormFieldAnswer(with: $0, andType:field.type) }
  }
}

struct FormFieldAnswer {
  var id: Int
  var value: String
  var type: EventRegFormFieldType

  init(with answer: EventRegFormFieldAnswerPlainObject,
       andType type: EventRegFormFieldType) {
    self.id = answer.id
    self.value = answer.value
    self.type = type
  }
}

struct FieldAnswer {
  var id: Int
  var fieldId: String
  var userId: String
  var answer: String
}
