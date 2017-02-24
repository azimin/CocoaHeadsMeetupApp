//
//  ExtensionString.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 23/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation

/* Helper extension for ImportController.swift
 put the number of seconds from 1970 to date
 */
extension String {

  var timeIntervalFrom1970: Double {
    let dateFormatter = DateFormatter()
    let dateString = self
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    let dat = dateFormatter.date(from: dateString)!
    return Double(dat.timeIntervalSince1970)
  }
}
