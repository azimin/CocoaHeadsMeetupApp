//
//  RegistrationPreviewData.swift
//  CHMeetupApp
//
//  Created by Maxim Globak on 05.03.17.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation

enum RegistrationPreviewFieldType {
  case textField
  case selectOne
  case selectMultiply
}

struct RegistrationPreviewData {
  var sections = [RegistrtionPreviewSection]()
}

struct RegistrtionPreviewSection {
  var title: String?
  var fields: [RegistrtionPreviewItem]
}

struct RegistrtionPreviewItem {
  var uid: String
  var shouldSave: Bool
  var isRequired: Bool
  var name: String
  var type: RegistrationPreviewFieldType
  var fieldAnswers: [RegistrtionPreviewFieldAnswer]

  // FIXME: - need init with object
}

struct RegistrtionPreviewFieldAnswer {
  var uid: String
  var value: String
}

struct RegistrtionPreviewAnswer {
  var uid: String
  var fieldId: String
  var userId: String
  var answer: String
}
