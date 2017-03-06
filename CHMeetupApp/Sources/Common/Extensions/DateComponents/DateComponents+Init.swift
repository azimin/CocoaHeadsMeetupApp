//
//  DateComponents+Init.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 27/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation

extension DateComponents {
  init(date: Date) {
    let calendar = Calendar.current
    let yearComponent = Int(calendar.component(.year, from: date))
    let monthComponent = Int(calendar.component(.month, from: date))
    let dayComponent = Int(calendar.component(.day, from: date))
    let hourComponent = Int(calendar.component(.hour, from: date))
    let minuteComponent = Int(calendar.component(.minute, from: date))

    self.init(year: yearComponent,
              month: monthComponent,
              day: dayComponent,
              hour: hourComponent,
              minute: minuteComponent)
  }
}
