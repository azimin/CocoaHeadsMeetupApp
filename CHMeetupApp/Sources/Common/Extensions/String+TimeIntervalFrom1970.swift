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
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    let date = dateFormatter.date(from: self)!
    return Double(date.timeIntervalSince1970)
  }
}
