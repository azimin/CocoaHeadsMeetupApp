//
//  Date+LocalizedFormat.swift
//  CHMeetupApp
//
//  Created by Maxim Globak on 28.03.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

extension Date {

  enum DateTemplate: String {
    case event = "MMMM dd, HH:mm"
  }

  private static let dateFormatter = DateFormatter()

  func dateString(with dateTemplate: DateTemplate) -> String {
    Date.dateFormatter.dateFormat = Date.dateFormat(for: dateTemplate)
    return Date.dateFormatter.string(from: self)
  }

  static func dateFormat(for dateTemplate: DateTemplate) -> String {
    let template = dateTemplate.rawValue
    let localeCode = Bundle.main.preferredLocalizations.first! as String
    let locale = Locale(identifier: localeCode)
    return DateFormatter.dateFormat(fromTemplate: template,
                                    options: 0,
                                    locale: locale)!
  }
}
