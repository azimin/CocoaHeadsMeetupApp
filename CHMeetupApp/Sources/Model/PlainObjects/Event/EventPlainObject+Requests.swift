//
//  EventPO+Requests.swift
//  CHMeetupApp
//
//  Created by Sam Mejlumyan on 03/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

extension EventPlainObject: PlainObjectType {

  struct Requests {
    // Events list
    static var list: Request<[EventPlainObject]> {
      return Request(query: "events")
    }
    
    // Past events list
    static var pastList: Request<[EventPlainObject]> {
      return Request(query: "events/past")
    }
  }

  init?(json: JSONDictionary) {
    guard
      let id = json["id"] as? Int,
      let title = json["title"] as? String,
      let description = json["description"] as? String,
      let photoUrl = json["photoUrl"] as? String,
      let startDate = json["startDate"] as? Double,
      let endDate = json["endDate"] as? Double,
      let placeJson = json["place"] as? JSONDictionary,
      let place = PlacePlainObject(json: placeJson)
      else { return nil }

    self.id = id
    self.title = title
    self.description = description
    self.place = place
    self.photoUrl = photoUrl
    self.startDate = Date(timeIntervalSince1970: startDate)
    self.endDate = Date(timeIntervalSince1970: endDate)
  }
}
