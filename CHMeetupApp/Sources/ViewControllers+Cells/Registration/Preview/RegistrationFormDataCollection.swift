//
//  RegistrationFormDataCollection.swift
//  CHMeetupApp
//
//  Created by Maxim Globak on 05.03.17.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation

class FormDataCollection {

  var data: FormData?

//  func setupCollection(withEventRegFields eventRegFields: [EventRegFormFieldPlainObject]) {
//
//    // Empty section for test
//    var section = FormSection(title: "", fields: [])
//
//    for eventRegField in eventRegFields {
//      let field = FieldItem(with: eventRegField)
//      section.fields.append(field)
//    }
//
//    data.sections.append(section)
//  }

  func loadRegFromServer(withId id: String, complitionBlock: @escaping () -> Void) {
    // FIXME: - just for test, delete after linking with real model
    Server.request(EventRegFormPlainObject.Requests.one(id: id)) { (form, error) in
      if let error = error {
        print(error)
      }
      if form != nil {
        self.data = FormData(with: form!)
        complitionBlock()
      }
    }
  }

}
