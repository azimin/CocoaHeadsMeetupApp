//
//  EventEntity.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 04/03/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation
import RealmSwift

class EventEntity: Object {
  dynamic var id: Int = 0

  dynamic var title: String = ""
  dynamic var descriptionText: String = ""

  dynamic var startDate: Date?
  dynamic var endDate: Date?
  
  dynamic var photoURL: String = ""

  dynamic var place: PlaceEntity?

  let speeches = List<SpeechEntity>()

  override static func primaryKey() -> String? {
    return "id"
  }
}
