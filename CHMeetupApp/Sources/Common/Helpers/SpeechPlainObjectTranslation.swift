//
//  SpeechPlainObjectTranslation.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 26/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

struct SpeechPlainObjectTranslation: PlainObjectTranslation {
  static func addToRealm(plainObject: SpeechPlainObject, to parent: EventEntity? = nil) {
    assert(parent != nil, "Parent should exist")

    let speakerPlainObject = plainObject.speaker

    //TODO: Move out this translation of here
    let user = UserEntity()
    user.id = speakerPlainObject.id
    user.name = speakerPlainObject.name
    user.lastName = speakerPlainObject.lastname
    user.photoURL = speakerPlainObject.photoUrl
    user.company = speakerPlainObject.company

    let speech = SpeechEntity()
    speech.id = plainObject.id
    speech.title = plainObject.title
    speech.descriptionText = plainObject.description

    user.speeches.append(speech)

    for contentPlainObject in plainObject.content {
      let content = SpeechContentEntity()
      content.id = contentPlainObject.id
      content.title = contentPlainObject.title
      content.type = contentPlainObject.type.rawValue
      content.linkURL = contentPlainObject.linkURL.absoluteString

      speech.contents.append(content)
    }

    realmWrite {
      mainRealm.add(user, update: true)
      parent?.speeches.append(speech)

      // Because it doesn't check dublicates by itself and we can have same objects in one lust
      parent?.speeches.removeDublicates(rule: { $0.id })
      speech.contents.removeDublicates(rule: { $0.id })
    }
  }
}
