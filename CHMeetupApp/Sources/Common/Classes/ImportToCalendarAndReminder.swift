//
//  ImportToCalendarAndReminder.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 23/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import EventKit

class ImportTo {
  func ToCalendar(eventStore: EKEventStore, title: String, location: String, startTime: String, endTime: String) {
    eventStore.requestAccess(to: .event, completion: {(_, _) in})
    let event = EKEvent(eventStore: eventStore)
    event.title = title
    event.location = location
    event.startDate = Date(timeIntervalSince1970: startTime.dateSince)
    event.endDate = Date(timeIntervalSince1970: endTime.dateSince)
    event.calendar = eventStore.defaultCalendarForNewEvents
    do {
      try eventStore.save(event, span: .thisEvent)
    } catch {
      print("Sorry")
    }
  }
  func ToReminder(eventStore: EKEventStore, title: String, location: String, startTime: String, endTime: String) {
    eventStore.requestAccess(to: .reminder, completion: {(_, _) in })
    let reminder = EKReminder(eventStore: eventStore)
    reminder.title = title
    reminder.location = location
    reminder.isCompleted = false
    reminder.dueDateComponents = DateComponents(year: 2017, month: 02, day: 24, hour: 11, minute: 00)
    reminder.calendar = eventStore.defaultCalendarForNewReminders()
    do {
      try eventStore.save(reminder, commit: true)
      print("okay")
    } catch {
      print("Sorry")
    }
  }
}
