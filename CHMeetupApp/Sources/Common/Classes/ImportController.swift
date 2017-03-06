//
//  ImportToCalendarAndReminder.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 23/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import EventKit
import UIKit

enum ImportToType {
  case calendar
  case reminder
}

class Importer {

  enum Result {
    case success
    case permissionError
    case saveError(error: Error)
  }

  private static let calendarEventStore = EKEventStore()
  private static let remindersEventStore = EKEventStore()

  typealias ResultParametr = (_ result: Result) -> Void

  static func `import`(event: EventEntity, to type: ImportToType, completion: @escaping ResultParametr) {
    switch type {
    case .calendar:
      importToCalendar(infoAboutEvent: event, completion: completion)
    case .reminder:
      importToReminder(infoAboutEvent: event, completion: completion)
    }
  }

  private static func importToCalendar(infoAboutEvent: EventEntity, completion: @escaping ResultParametr) {
    calendarEventStore.requestAccess(to: .event, completion: { granted, error in
      guard granted else {
        completion(.permissionError)
        return
      }

      let event = EKEvent(eventStore: self.calendarEventStore)

      let structuredLocation = EKStructuredLocation(title: infoAboutEvent.place?.city ?? "Bad Location")
      if let place = infoAboutEvent.place {
        structuredLocation.geoLocation = CLLocation(latitude: place.latitude,
                                                    longitude: place.longitude)
      }
      //warn the user for five hours before event 5 hours = 18000 seconds
      let alarm = EKAlarm(relativeOffset:-(5 * 60 * 60))

      event.title = infoAboutEvent.title
      event.startDate = Date(timeIntervalSince1970: 1491580800)
      event.endDate = Date(timeIntervalSince1970: 1491595200)
      event.notes = infoAboutEvent.descriptionText
      event.structuredLocation = structuredLocation
      event.addAlarm(alarm)
      event.calendar = self.calendarEventStore.defaultCalendarForNewEvents

      do {
        try self.calendarEventStore.save(event, span: .thisEvent)
        completion(.success)
      } catch {
        print("Event Store save error: \(error), event: \(event)".localized)
        completion(.saveError(error: error))
      }

    })
  }

  private static func importToReminder(infoAboutEvent: EventEntity, completion: @escaping ResultParametr) {
    remindersEventStore.requestAccess(to: .reminder, completion: { granted, error in
      guard granted else {
        completion(.permissionError)
        return
      }

      let reminder = EKReminder(eventStore: self.remindersEventStore)
      let intervalSince1970 = Date(timeIntervalSince1970: 1491580800)
      let alarmDate = intervalSince1970 - (5 * 60 * 60)
      let alarm = EKAlarm(absoluteDate: alarmDate)

      reminder.title = infoAboutEvent.title
      reminder.dueDateComponents = DateComponents(date: Date(timeIntervalSince1970: 1491595200))
      reminder.calendar = self.remindersEventStore.defaultCalendarForNewReminders()
      reminder.addAlarm(alarm)

      do {
        try self.remindersEventStore.save(reminder, commit: true)
        completion(.success)
      } catch {
        print("Event Store save error: \(error), event: \(reminder)".localized)
        completion(.saveError(error: error))
      }
    })
  }
}
