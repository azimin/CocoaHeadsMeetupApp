//
//  Date+Compare.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 17/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

extension Date {
  func isLater(then date: Date) -> Bool {
    return self.timeIntervalSince1970 > date.timeIntervalSince1970
  }
}
