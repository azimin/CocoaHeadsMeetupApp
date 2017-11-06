//
//  GiveSpeechPlainObjectTranslation.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 16/08/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

struct GiveSpeechPlainObjectTranslation: PlainObjectTranslation {
  static func addToRealm(plainObject: GiveSpeechPlainObject, to parent: GiveSpeechEntity? = nil) {

    let speech = GiveSpeechEntity()
    speech.id = plainObject.id
    speech.title = plainObject.title
    speech.descriptionText = plainObject.description
    speech.statusValue = plainObject.giveSpeechStatus

    realmWrite {
      mainRealm.add(speech, update: true)
    }
  }
}
