//
//  TemplateObject.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 27/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation
import RealmSwift

class TemplatableObject: Object {
  dynamic var isTemplate: Bool = false
  override class func ignoredProperties() -> [String] {
    return ["isTemplate"]
  }
}
