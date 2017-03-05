//
//  RegistrationPreviewData.swift
//  CHMeetupApp
//
//  Created by Maxim Globak on 05.03.17.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation

// // // // // // // // // // // // // // //
// FIXME: - Delete after creating real model for question
struct Question {
  var name: String
  var type: RegistrationPreviewFieldType
}
// // // // // // // // // // // // // // //

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
  var fields: [RegistrtionPreviewField]
}

struct RegistrtionPreviewField {
  var uid: String
  var name: String
  var type: RegistrationPreviewFieldType
  
  init(entity: Question) {
    self.uid = UUID().uuidString
    self.name = entity.name
    self.type = entity.type
  }
  
  struct RegistrtionPreviewAnswer {
    var uid: String
    var fieldId: String
    var userId: String
    var answer: String
  }
}
