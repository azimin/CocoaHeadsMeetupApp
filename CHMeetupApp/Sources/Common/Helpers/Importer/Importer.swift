//
//  ImportToCalendarAndReminder.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 23/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import EventKit
import UIKit

enum ImportType {
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

  static func `import`(event: EventEntity, to type: ImportType, completion: @escaping ResultParameter) {
    switch type {
    case .calendar:
      tryImportToCalendar(event: event, completion: completion)
    case .reminder:
      tryImportToReminder(event: event, completion: completion)
    }
  }

  private static func tryImportToCalendar(event: EventEntity, completion: @escaping ResultParameter) {
    calendarEventStore.requestAccess(to: .event, completion: { granted, _ in
      guard granted else {
        OperationQueue.main.addOperation {
          completion(.permissionError)
        }
        return
      }
      OperationQueue.main.addOperation {
        importToCalendar(event: event, completion: completion)
      }
    })
  }

  private static func importToCalendar(event: EventEntity, completion: @escaping ResultParameter) {
    let calendarEvent = EKEvent(eventStore: self.calendarEventStore)
    // warn the user for five hours before event 5 hours = 18000 seconds
    let alarm = EKAlarm(relativeOffset: -(5 * 60 * 60))

    calendarEvent.title = event.title
    calendarEvent.startDate = event.startDate
    calendarEvent.endDate = event.endDate
    calendarEvent.notes = event.descriptionText
    calendarEvent.addAlarm(alarm)
    calendarEvent.calendar = self.calendarEventStore.defaultCalendarForNewEvents

    if let place = event.place {
      let location = place.title
      let structuredLocation = EKStructuredLocation(title: location)
      structuredLocation.geoLocation = CLLocation(latitude: place.latitude,
                                                  longitude: place.longitude)
      calendarEvent.structuredLocation = structuredLocation
    }

    do {
      try self.calendarEventStore.save(calendarEvent, span: .thisEvent)
      completion(.success)
    } catch {
      print("Event Store save error: \(error), event: \(calendarEvent)")
      completion(.saveError(error: error))
    }
  }

  private static func tryImportToReminder(event: EventEntity, completion: @escaping ResultParameter) {
    remindersEventStore.requestAccess(to: .reminder, completion: { granted, _ in
      guard granted else {
        OperationQueue.main.addOperation {
        completion(.permissionError)
        }
        return
      }

      OperationQueue.main.addOperation {
        importToReminder(event: event, completion: completion)
      }
    })
  }

  private static func importToReminder(event: EventEntity, completion: @escaping ResultParameter) {
    let reminder = EKReminder(eventStore: self.remindersEventStore)
    let intervalSince1970 = event.startDate.timeIntervalSince1970
    let alarmDate = Date(timeIntervalSince1970: intervalSince1970 - (5 * 60 * 60))
    let alarm = EKAlarm(absoluteDate: alarmDate)

    reminder.title = event.title
    reminder.dueDateComponents = DateComponents(date: event.startDate)
    reminder.calendar = self.remindersEventStore.defaultCalendarForNewReminders()
    reminder.addAlarm(alarm)

    do {
      try self.remindersEventStore.save(reminder, commit: true)
      completion(.success)
    } catch {
      print("Event Store save error: \(error), event: \(reminder)")
      completion(.saveError(error: error))
    }
  }
}
