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
    let dateFormatter = Date.dateFormatter

    dateFormatter.dateFormat = Date.dateFormat(for: dateTemplate)
    return dateFormatter.string(from: self)
  }

  static func dateFormat(for dateTemplate: DateTemplate) -> String {
    let template = dateTemplate.rawValue
    let local = Bundle.main.locale
    return DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: local) ?? template
  }
}
