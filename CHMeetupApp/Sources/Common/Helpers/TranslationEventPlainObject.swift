//
//  TranslateEventPlainObject.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 19/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation
import RealmSwift

struct EventPlainObjectTranslation: PlainObjectTranslation {
  static func addToRealm(plainObject: EventPlainObject, to parent: EventEntity? = nil) {
    let event = EventEntity()
    event.id = plainObject.id
    event.title = plainObject.title
    event.startDate = plainObject.startDate
    event.endDate = plainObject.endDate
    event.descriptionText = plainObject.description
    event.statusValue = plainObject.registrationStatus

    for speakerURLs in plainObject.speakersPhotos {
      let containerEntity = StringContainerEntity()
      containerEntity.value = speakerURLs.absoluteString
      event.speakerPhotosURLs.append(containerEntity)
    }

    let place = PlaceEntity()
    place.id = plainObject.place.placeID
    place.title = plainObject.place.title
    place.address = plainObject.place.address
    place.latitude = plainObject.place.latitude
    place.longitude = plainObject.place.longitude
    place.city = plainObject.place.cityName
    event.place = place
    _ = ImportingStateEntity.createOrGet(for: plainObject.id)
    realmWrite {
      mainRealm.add(event, update: true)
      mainRealm.add(place, update: true)
    }
  }
}
