//
//  Date+DefaultFormat.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 17/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

extension Date {
  /// If current year, then would show date and month (example: 7 April) depending on locale
  /// If another year, it would add year (example: 7 April 2016) depeding on locale
  var defaultFormatString: String {
    let template = self.isThisYear ? "MMMMd" : "yMMMMd"
    let dateFormatString = DateFormatter.dateFormat(fromTemplate: template,
                                                    options: 0,
                                                    locale: .current)

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormatString
    dateFormatter.locale = Bundle.main.locale
    return dateFormatter.string(from: self)
  }
}
