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

  typealias ResultParameter = (_ result: Result) -> Void

  static func `import`(event: EventEntity, to type: ImportToType, completion: @escaping ResultParameter) {
    switch type {
    case .calendar:
      importToCalendar(event: event, completion: completion)
    case .reminder:
      importToReminder(event: event, completion: completion)
    }
  }

  private static func importToCalendar(event: EventEntity, completion: @escaping ResultParameter) {
    calendarEventStore.requestAccess(to: .event, completion: { granted, error in
      guard granted else {
        completion(.permissionError)
        return
      }

      let calendar = EKEvent(eventStore: self.calendarEventStore)

      let location = (event.place?.title ?? "Bad location")

      let structuredLocation = EKStructuredLocation(title: location)
      if let place = event.place {
        structuredLocation.geoLocation = CLLocation(latitude: place.latitude,
                                                    longitude: place.longitude)
      }
      // warn the user for five hours before event 5 hours = 18000 seconds
      let alarm = EKAlarm(relativeOffset:-(5 * 60 * 60))

      calendar.title = event.title.localized

      // FIXME: -Add end-date to REALM
      if let startDate = event.date {
        calendar.startDate = startDate
      }
      calendar.structuredLocation = structuredLocation
      calendar.addAlarm(alarm)
      calendar.calendar = self.calendarEventStore.defaultCalendarForNewEvents

      do {
        try self.calendarEventStore.save(calendar, span: .thisEvent)
        completion(.success)
      } catch {
        print("Event Store save error: \(error), event: \(event)")
        completion(.saveError(error: error))
      }

    })
  }

  private static func importToReminder(event: EventEntity, completion: @escaping ResultParameter) {
    remindersEventStore.requestAccess(to: .reminder, completion: { granted, error in
      guard granted else {
        completion(.permissionError)
        return
      }

      let reminder = EKReminder(eventStore: self.remindersEventStore)

        if let date = event.date {
        let intervalSince1970 = date
        let alarmDate = intervalSince1970 - (5 * 60 * 60)

        reminder.dueDateComponents = DateComponents(date: date)

        let alarm = EKAlarm(absoluteDate: alarmDate)
        reminder.addAlarm(alarm)
      }
      reminder.title = event.title.localized
      reminder.calendar = self.remindersEventStore.defaultCalendarForNewReminders()

      do {
        try self.remindersEventStore.save(reminder, commit: true)
        completion(.success)
      } catch {
        print("Event Store save error: \(error), event: \(reminder)")
        completion(.saveError(error: error))
      }
    })
  }
}
