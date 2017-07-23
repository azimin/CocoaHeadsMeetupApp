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
    case loading
    case registrationClosed

    var allowRegister: Bool {
      switch self {
      case .canRegister:
        return true
      case .waiting, .rejected, .approved, .unknown, .loading, .registrationClosed:
        return false
      }
    }

    var statusText: String {
      switch self {
      case .waiting:
        return "Ожидайте подтверждения".localized
      case .rejected:
        return "К сожалению, заявка отклонена".localized
      case .approved:
        return "Заявка одобрена. Ждём вас!".localized
      case .canRegister:
        return "Я пойду".localized
      case .unknown:
        return "Нет статуса".localized
      case .loading:
        return "Загрузка статуса".localized
      case .registrationClosed:
        return "Регистрация закрыта".localized
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

  var importingState: ImportingStateEntity {
    if let importingState = mainRealm.objects(ImportingStateEntity.self).first(where: { $0.eventId == id }) {
      return importingState
    } else {
      assertionFailure("No import state entity")
      return ImportingStateEntity()
    }
  }

  var shouldShowRegistrationStatus: Bool {
    return isUpcomingEvent
  }

  var isUpcomingEvent: Bool {
    return endDate.timeIntervalSince1970 > Date().timeIntervalSince1970
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
    realmWrite {
      // Because our isUpcomingEvent always show status button we want
      // to show loading state before we would load any events from server
      for entity in mainRealm.objects(EventEntity.self) {
        if entity.isUpcomingEvent {
          entity.status = .loading
        } else {
          entity.status = .unknown
        }
      }
    }
  }

  // After upcomming events loading we want to reset status of NON updated 
  // objects to unknow (for example not internet connection)
  // This one should be improved in future, when we would have > 1 VC for upcomming events or would implement deep links
  static func resetLoadingEntitiesStatus() {
    realmWrite {
      for entity in mainRealm.objects(EventEntity.self)
        where entity.status == .loading {
        entity.status = .unknown
      }
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
    entity.speeches.append(SpeechEntity.templateEntity)
    entity.isTemplate = true
    return entity
  }
}
