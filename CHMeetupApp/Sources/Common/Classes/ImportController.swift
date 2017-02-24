//
//  ImportToCalendarAndReminder.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 23/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import EventKit
import UIKit

struct InfoAboutEvent {
  var title = "CocoaHeadsRule"
  var startTime = "2017-02-24 6:00"
  var endTime = "2017-02-24 7:00"
  var location = CLLocation(latitude: 59.9386, longitude: 30.3141)
  var locationTitle = "Saint-Petersburg"
  var notes = "Take your MacBook for coding!"
}

class ImportController {

  func toCalendar(eventStore: EKEventStore, infoAboutQuest: InfoAboutEvent) {
    eventStore.requestAccess(to: .event, completion: { granted, error in
      if granted {
        let event = EKEvent(eventStore: eventStore)
        let structuredLocation = EKStructuredLocation(title: infoAboutQuest.locationTitle)
        structuredLocation.geoLocation = infoAboutQuest.location

        event.title = infoAboutQuest.title
        event.startDate = Date(timeIntervalSince1970: infoAboutQuest.startTime.timeIntervalFrom1970)
        event.endDate = Date(timeIntervalSince1970: infoAboutQuest.endTime.timeIntervalFrom1970)
        event.notes = infoAboutQuest.notes
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
