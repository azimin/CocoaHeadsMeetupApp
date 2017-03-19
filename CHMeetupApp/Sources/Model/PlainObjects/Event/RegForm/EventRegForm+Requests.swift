//
//  EventRegForm+Requests.swift
//  CHMeetupApp
//
//  Created by Sam Mejlumyan on 07/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

extension EventRegFormPlainObject: PlainObjectType {

  struct Requests {
    static func form(with id: Int) -> Request<EventRegFormPlainObject> {
      return Request<EventRegFormPlainObject>(query: "event/form/\(id)", method: .get)
    }
  }

  init?(json: JSONDictionary) {
    guard
      let id = json["id"] as? Int,
      let name = json["form_name"] as? String,
      let regFields = json["reg_fields"] as? [JSONDictionary]
      else { return nil }

    self.id = id
    self.name = name
    self.fields = regFields.flatMap(EventRegFormFieldPlainObject.init)
  }
}
