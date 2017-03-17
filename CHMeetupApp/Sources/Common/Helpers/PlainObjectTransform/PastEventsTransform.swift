//
//  PastEvents.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 17/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

class PastEventsTransform {
  static func plainObject(in pastEvent: EventPlainObject) -> EventEntity {
    let event = EventEntity()
    event.id = pastEvent.id
    event.title = pastEvent.title
    event.startDate = pastEvent.startDate
    event.endDate = pastEvent.endDate
    event.photoURL = pastEvent.photoUrl
    event.descriptionText = pastEvent.description

    let place = PlaceEntity()
    place.id = pastEvent.place.placeID
    place.title = pastEvent.place.title
    place.address = pastEvent.place.address
    place.latitude = pastEvent.place.latitude
    place.longitude = pastEvent.place.longitude

    event.place = place
    return event
  }
}
