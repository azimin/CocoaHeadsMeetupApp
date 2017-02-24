//
//  ImportToCalendarAndReminder.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 23/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import EventKit
import UIKit

class ImportController {

  func toCalendar(eventStore: EKEventStore, title: String, location: String, startTime: String, endTime: String) {
    eventStore.requestAccess(to: .event, completion: { granted, error in
      if granted {
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.location = location
        event.startDate = Date(timeIntervalSince1970: startTime.timeIntervalFrom1970)
        event.endDate = Date(timeIntervalSince1970: endTime.timeIntervalFrom1970)
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
          try eventStore.save(event, span: .thisEvent)
        } catch {
          print("Event Store save error: \(error), event: \(event)") }
      } else {
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, completionHandler: { (success) in
          print("Settings opened: \(success)") })
      }
    })
  }

  func toReminder(eventStore: EKEventStore, title: String, location: String, startTime: String, endTime: String) {
    eventStore.requestAccess(to: .reminder, completion: { granted, error in
      if granted {
        let reminder = EKReminder(eventStore: eventStore)
        reminder.title = title
        reminder.location = location
        reminder.isCompleted = false
        reminder.dueDateComponents = DateComponents(year: 2017, month: 02, day: 24, hour: 11, minute: 00)
        reminder.calendar = eventStore.defaultCalendarForNewReminders()
        do {
          try eventStore.save(reminder, commit: true)
        } catch {
          print("Event Store save error: \(error), event: \(reminder)") }
      } else {
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, completionHandler: { (success) in
          print("Settings opened: \(success)") })
      }
    })
  }
}
