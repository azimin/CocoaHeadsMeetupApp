//
//  TranslationPlainObjectProtocol.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 19/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation
import RealmSwift

protocol PlainObjectTranslation {
  associatedtype Value = PlainObjectType
  // Would be Realm class to ref to something
  associatedtype Parent = Object

  static func translate(of plainObjects: [Value], to parent: Parent?)
  static func addToRealm(plainObject: Value, to parent: Parent?)
}

extension PlainObjectTranslation {
  static func translate(of plainObjects: [Value], to parent: Parent?) {
    plainObjects.forEach({
      addToRealm(plainObject: $0, to: parent)
    })
  }
}
