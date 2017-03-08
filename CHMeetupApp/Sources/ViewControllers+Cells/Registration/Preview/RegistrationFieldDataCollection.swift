//
//  RegistrationFieldDataCollection.swift
//  CHMeetupApp
//
//  Created by Maxim Globak on 05.03.17.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation

class RegistrationFieldDataCollection {

  var dataCollection = RegistrationFieldData()

  func setupCollection(withEventRegFields eventRegFields: [EventRegFormFieldPlainObject]) {

    // Empty section for test
    var section = RegistrationFieldSection(title: "", fields: [])

    for eventRegField in eventRegFields {
      let field = RegistrationFieldItem.init(with: eventRegField)
      section.fields.append(field)
    }

    dataCollection.sections.append(section)
  }

  func loadFieldsFromServer(complitionBlock: @escaping () -> Void) {
    Server.request(EventRegFormPlainObject.Requests.one(id: "1")) { (form, error) in
      if let error = error {
        print(error)
      }
      if let formFields = form?.fields {
        self.setupCollection(withEventRegFields: formFields)
        complitionBlock()
      }
    }
  }

}
