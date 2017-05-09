//
//  EventEntity.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 04/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation
import RealmSwift

final class EventEntity: TemplatableObject, TemplateEntity {

  enum EventRegistrationStatus: String {
    case waiting
    case rejected
    case approved
    case canRegister
    case unknown

    var allowRegister: Bool {
      switch self {
      case .canRegister:
        return true
      case .waiting, .rejected, .approved, .unknown:
        return false
      }
    }

    var statusText: String {
      switch self {
      case .waiting:
        return "Ожидайте подтверждения".localized
      case .rejected:
        return "Жаль, заявка отклонена".localized
      case .approved:
        return "Заявка одобрена. Ждём вас!".localized
      case .canRegister:
        return "Я пойду".localized
      case .unknown:
        return "Нет статуса".localized
      }
    }
  }

  dynamic var id: Int = 0

  dynamic var title: String = ""
  dynamic var descriptionText: String = ""

  dynamic var startDate: Date = Date()
  dynamic var endDate: Date = Date()

  dynamic var photoURL: String = ""

  dynamic var statusValue: String = "unknown"
  var status: EventRegistrationStatus {
    get {
      return EventRegistrationStatus(rawValue: statusValue) ?? .unknown
    }
    set {
      realmWrite {
        statusValue = newValue.rawValue
      }
    }
  }

  dynamic var place: PlaceEntity?
  dynamic var isRegistrationOpen: Bool = false

  var importingState: ImportingStateEntity {
    if let importingState = mainRealm.objects(ImportingStateEntity.self).first(where: { $0.eventId == id }) {
      return importingState
    } else {
      assertionFailure("No import state entity")
      return ImportingStateEntity()
    }
  }

  var shouldShowRegistrationStatus: Bool {
    return isRegistrationOpen && status != .unknown
  }

  let speeches = List<SpeechEntity>()
  let speakerPhotosURLs = List<StringContainerEntity>()

  override static func primaryKey() -> String? {
    return "id"
  }

  override class func ignoredProperties() -> [String] {
    return super.ignoredProperties() + ["status"]
  }

  static func resetEntitiesStatus() {
    for entity in mainRealm.objects(EventEntity.self) {
      entity.status = EventRegistrationStatus.unknown
    }
  }
}

extension EventEntity {
  static var templateEntity: EventEntity {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd"

    let entity = EventEntity()
    entity.title = "CocoaHeads Meetup"
    entity.descriptionText = "Совсем скоро в петербургском офисе Яндекса первая встреча сообщества CocoaHeads Russia."
    entity.startDate <= formatter.date(from: "20161111")
    entity.endDate <= formatter.date(from: "20161111")
    entity.photoURL = "https://avatars.mds.yandex.net/get-yaevents/194464/552b2574b7b911e6afd30025909419be/320x240"
    entity.place = PlaceEntity.templateEntity
    entity.statusValue = EventEntity.EventRegistrationStatus.unknown.rawValue
    entity.isRegistrationOpen = false
    entity.speeches.append(SpeechEntity.templateEntity)
    entity.isTemplate = true
    return entity
  }
}
