//
//  EventPO.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 24/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import CoreLocation

struct EventPlainObject {
  let id: Int
  let title: String
  let description: String
  let place: PlacePlainObject
  let startDate: Date
  let endDate: Date
  let photoUrl: String
}
