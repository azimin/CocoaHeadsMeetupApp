//
//  RegistrationPreviewDataCollection.swift
//  CHMeetupApp
//
//  Created by Maxim Globak on 05.03.17.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation

class RegistrationPreviewDataCollection {

  var dataCollection = RegistrationPreviewData()

  func setupCollection(questions: [Question]) {

    // Sample section
    var section = RegistrtionPreviewSection(title: "", fields: [])
    dataCollection.sections.append(section)

    for question in questions {
      let field = RegistrtionPreviewField.init(entity: question)
      section.fields.append(field)
    }

    dataCollection.sections.append(section)
  }

}
