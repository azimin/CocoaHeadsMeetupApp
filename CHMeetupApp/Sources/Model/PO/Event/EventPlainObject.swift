//
//  EventPO.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 24/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import CoreLocation

struct EventPlainObject {
  let id: Int
  let title: String
  let desc: String
  let place: PlacePlainObject
  let startDate: Date
  let endDate: Date
  let photoUrl: String
}
