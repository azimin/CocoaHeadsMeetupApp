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

  static let addTo: ImportController = {
    let add = ImportController()
    return add
  }()
  let eventStore = EKEventStore()

  func toCalendar(infoAboutEvent: InfoAboutEvent) {
    eventStore.requestAccess(to: .event, completion: { granted, error in
      if granted {
        let event = EKEvent(eventStore: self.eventStore)
        let structuredLocation = EKStructuredLocation(title: infoAboutEventt.locationTitle)
        let alarm = EKAlarm(relativeOffset:-18000)
        structuredLocation.geoLocation = infoAboutEventt.location

        event.title = infoAboutEventt.title
        event.startDate = Date(timeIntervalSince1970: infoAboutEventt.startTime.timeIntervalFrom1970)
        event.endDate = Date(timeIntervalSince1970: infoAboutEventt.endTime.timeIntervalFrom1970)
        event.notes = infoAboutEventt.notes
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

  func toReminder(infoAboutEvent: InfoAboutEvent) {
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
