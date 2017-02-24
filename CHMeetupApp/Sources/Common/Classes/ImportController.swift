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

  static let eventStore = EKEventStore()

   static func toCalendar(infoAboutEvent: EventPO) {
    eventStore.requestAccess(to: .event, completion: { granted, error in
      if granted {
        let event = EKEvent(eventStore: self.eventStore)
        let structuredLocation = EKStructuredLocation(title: infoAboutEvent.locationTitle)
        //warn the user for five hours before event 5 hours = 18000 seconds
        let alarm = EKAlarm(relativeOffset:-18000)
        structuredLocation.geoLocation = infoAboutEvent.location

        event.title = infoAboutEvent.title
        event.startDate = Date(timeIntervalSince1970: infoAboutEvent.startTime.timeIntervalFrom1970)
        event.endDate = Date(timeIntervalSince1970: infoAboutEvent.endTime.timeIntervalFrom1970)
        event.notes = infoAboutEvent.notes
        event.addAlarm(alarm)
        event.calendar = self.eventStore.defaultCalendarForNewEvents
        do {
          try self.eventStore.save(event, span: .thisEvent)
        } catch {
          print("Event Store save error: \(error), event: \(event)") }
      } else {
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, completionHandler: { (success) in
          print("Settings opened: \(success)") })
      }
    })
  }

  static func toReminder(infoAboutEvent: EventPO) {
    eventStore.requestAccess(to: .reminder, completion: { granted, error in
      if granted {
        let reminder = EKReminder(eventStore: self.eventStore)
        reminder.title = infoAboutEvent.title
        reminder.calendar = self.eventStore.defaultCalendarForNewReminders()
        do {
          try self.eventStore.save(reminder, commit: true)
        } catch {
          print("Event Store save error: \(error), event: \(reminder)") }
      } else {
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, completionHandler: { (success) in
          print("Settings opened: \(success)") })
      }
    })
  }
}
