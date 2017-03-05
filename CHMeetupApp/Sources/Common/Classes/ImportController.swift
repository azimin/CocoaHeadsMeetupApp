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

  static func `import`(event: EventPO, to type: ImportToType, completion: @escaping ResultParametr) {
    switch type {
    case .calendar:
      importToCalendar(infoAboutEvent: event, completion: completion)
    case .reminder:
      importToReminder(infoAboutEvent: event, completion: completion)
    }
  }

  private static func importToCalendar(infoAboutEvent: EventPO, completion: @escaping ResultParametr) {
    calendarEventStore.requestAccess(to: .event, completion: { granted, error in
      guard granted else {
        completion(.permissionError)
        return
      }
      let event = EKEvent(eventStore: self.calendarEventStore)
      let structuredLocation = EKStructuredLocation(title: infoAboutEvent.locationTitle)
      //warn the user for five hours before event 5 hours = 18000 seconds
      let alarm = EKAlarm(relativeOffset:-(5 * 60 * 60))

      event.title = infoAboutEvent.title
      event.startDate = infoAboutEvent.startTime
      event.endDate = infoAboutEvent.endTime
      // FIXME: - Right value
     // event.notes = infoAboutEvent.infoAboutEvent
      event.addAlarm(alarm)
      event.calendar = self.calendarEventStore.defaultCalendarForNewEvents

      structuredLocation.geoLocation = infoAboutEvent.location
      event.structuredLocation = structuredLocation

      do {
        try self.calendarEventStore.save(event, span: .thisEvent)
        completion(.success)
      } catch {
        print("Event Store save error: \(error), event: \(event)".localized)
        completion(.saveError(error: error))
      }

    })
  }

  private static func importToReminder(infoAboutEvent: EventPO, completion: @escaping ResultParametr) {
    remindersEventStore.requestAccess(to: .reminder, completion: { granted, error in
      guard granted else {
        completion(.permissionError)
        return
      }

      let reminder = EKReminder(eventStore: self.remindersEventStore)
      let intervalSince1970 = infoAboutEvent.startTime.timeIntervalSince1970
      let alarmDate = Date(timeIntervalSince1970:  intervalSince1970 - (5 * 60 * 60))
      let alarm = EKAlarm(absoluteDate: alarmDate)

      reminder.title = infoAboutEvent.title
      reminder.dueDateComponents = DateComponents(date: infoAboutEvent)
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
