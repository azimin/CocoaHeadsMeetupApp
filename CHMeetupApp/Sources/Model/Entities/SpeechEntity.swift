//
//  SpeechEntity.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 04/03/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation
import RealmSwift

class SpeechEntity: Object {
  dynamic var id: Int = 0

  dynamic var title: String = ""
  dynamic var descriptionText: String = ""

  let contents = List<SpeechContentEntity>()

  private let users = LinkingObjects(fromType: UserEntity.self, property: "speeches")
  private let events = LinkingObjects(fromType: EventEntity.self, property: "speeches")

  var user: UserEntity? {
    return users.first
  }

  var event: EventEntity? {
    return events.first
  }

  override static func primaryKey() -> String? {
    return "id"
  }
}
