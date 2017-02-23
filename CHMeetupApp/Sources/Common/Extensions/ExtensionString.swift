//
//  ExtensionString.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 23/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation

extension String {
  var dateFromString: Date? {
    return Date.formatterFromString.date(from: self)
  }
}
