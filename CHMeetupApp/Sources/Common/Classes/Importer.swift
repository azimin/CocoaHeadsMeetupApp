//
//  ImportToCalendarAndReminder.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 23/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import EventKit
import UIKit

class Importer {

  enum `Type` {
    case calendar
    case reminder
}
  enum Result {
    case success
    case permissionError
    case saveError(error: Error)
  }

  private static let calendarEventStore = EKEventStore()
  private static let remindersEventStore = EKEventStore()

  typealias ResultParameter = (_ result: Result) -> Void

  static func `import`(event: EventEntity, to type: Type, completion: @escaping ResultParameter) {
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
      var location: String
      var structuredLocation: EKStructuredLocation

      if let place = event.place {
        location = place.title
        structuredLocation = EKStructuredLocation(title: location)
        structuredLocation.geoLocation = CLLocation(latitude: place.latitude,
                                                    longitude: place.longitude)
        calendar.structuredLocation = structuredLocation

      }
      // warn the user for five hours before event 5 hours = 18000 seconds
      let alarm = EKAlarm(relativeOffset:-(5 * 60 * 60))

      calendar.title = event.title
      calendar.notes = event.descriptionText
      if let startDate = event.startDate {
        calendar.startDate = startDate
      }
      if let endDate = event.endDate {
        calendar.endDate = endDate
      }

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

      var intervalSince1970: Date
      var alarmDate: Date
      if let startDate = event.startDate {
        intervalSince1970 = startDate
        alarmDate = intervalSince1970 - (5 * 60 * 60)

        let alarm = EKAlarm(absoluteDate: alarmDate)
        reminder.addAlarm(alarm)
      }
      if let endDate = event.endDate {
        reminder.dueDateComponents = DateComponents(date: endDate)
      }

      reminder.title = event.title
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
