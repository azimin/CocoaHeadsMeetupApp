//
//  Date+ComponentsHelper.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 17/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

extension Date {
  var isThisYear: Bool {
    let date = Date()
    let calendar = Calendar.current

    let todayYear = calendar.component(.year, from: date)
    let dateYaar = calendar.component(.year, from: self)

    return todayYear == dateYaar
  }

  var isPassed: Bool {
    return (self.isLater(then: Date()) == false)
  }
}
