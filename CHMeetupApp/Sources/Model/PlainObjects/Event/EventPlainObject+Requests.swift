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
      return Request(query: "events/index", method: .post, params: Constants.Server.baseParams)
    }

    // Past events list
    static var pastList: Request<[EventPlainObject]> {

      return Request(query: "events/past", method: .post, params: Constants.Server.baseParams)
    }

    // Event speakers list
    static func speakersOnEvent(with id: Int) -> Request<[UserPlainObject]> {
      return Request(query: "event/speakers/\(id)")
    }
  }

  init?(json: JSONDictionary) {
    guard
      let id = json["id"] as? Int,
      let title = json["title"] as? String,
      let description = json["description"] as? String,
      let photoUrl = json["photo_url"] as? String,
      let startDate = json["start_date"] as? Double,
      let endDate = json["end_date"] as? Double,
      let placeJson = json["place"] as? JSONDictionary,
      let speakersJson = json["speakers_photos"] as? [String],
      let registrationStatus = json["status"] as? String,
      let place = PlacePlainObject(json: placeJson)
    else { return nil }

    self.id = id
    self.title = title
    self.description = description
    self.photoUrl = photoUrl
    self.place = place
    self.startDate = Date(timeIntervalSince1970: startDate)
    self.endDate = Date(timeIntervalSince1970: endDate)
    self.registrationStatus = registrationStatus

    var photos: [URL] = []
    speakersJson.forEach { photoUrl in
      guard let url = URL(string: photoUrl) else { return }
      photos.append(url)
    }
    self.speakersPhotos = photos
  }
}
