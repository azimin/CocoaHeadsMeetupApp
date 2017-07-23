//
//  UserPlainObjectTranslation.swift
//  CHMeetupApp
//
//  Created by Dmitriy Lis on 29/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

struct CreatorPlainObjectTranslation: PlainObjectTranslation {
  static func addToRealm(plainObject: CreatorPlainObject, to parent: CreatorEntity? = nil) {
    let creator = CreatorEntity()
    creator.id = plainObject.id
    creator.name = plainObject.name
    creator.info = plainObject.info
    creator.photoURL = plainObject.photoUrl
    creator.url = plainObject.url
    creator.isActive = plainObject.isActive

    realmWrite {
      mainRealm.add(creator, update: true)
    }
  }
}
