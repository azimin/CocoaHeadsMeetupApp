//
//  ImportToCalendarAndReminder.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 23/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import EventKit

class ImportTo {
  private let eventStore = EKEventStore()
  
  func importToCalendar(title: String, location: String, startTime: String, endTime: String){
    let event = EKEvent(eventStore: eventStore)
    event.title = title
    event.location = location
    event.startDate = Date(timeIntervalSince1970: startTime.dateFrom)
    event.endDate = Date(timeIntervalSince1970: endTime.dateFrom)
    
  }
}
