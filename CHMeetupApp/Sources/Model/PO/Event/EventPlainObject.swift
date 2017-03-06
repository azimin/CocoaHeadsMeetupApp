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

// FIXME: Remove it

struct EventPO {
  var title = "Cocoa Heads"
  var startTime = Date(timeIntervalSince1970: 1488384000)
  var endTime = Date(timeIntervalSince1970: 1488398400)
  var location = CLLocation(latitude: 55.7784, longitude: 37.587802)
  var locationTitle = "Москва, штаб-квартира \"Авито\""
  var notes = "В программе интересные доклады, в перерывах кофе и снеки, а после автопати"
}
