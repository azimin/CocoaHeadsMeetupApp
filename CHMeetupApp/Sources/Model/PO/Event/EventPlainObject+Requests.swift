//
//  EventPO+Requests.swift
//  CHMeetupApp
//
//  Created by Sam Mejlumyan on 03/03/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation

extension EventPlainObject: PlainObjectType {

  struct Requests {
    // Events list
    static var list: Request<[EventPlainObject]> {
      return Request(query: "events")
    }
  }

  init?(json: JSONDictionary) {
    guard
      let id = json["id"] as? Int,
      let title = json["title"] as? String,
      let desc = json["description"] as? String,
      let photoUrl = json["photoUrl"] as? String,
      let startDate = json["startDate"] as? Double,
      let endDate = json["endDate"] as? Double,
      let placeJson = json["place"] as? JSONDictionary,
      let place = PlacePlainObject(json: placeJson)
      else { return nil }

    self.id = id
    self.title = title
    self.desc = desc
    self.place = place
    self.photoUrl = photoUrl
    self.startDate = Date(timeIntervalSince1970: startDate)
    self.endDate = Date(timeIntervalSince1970: endDate)
  }
}
