//
//  String+Localized.swift
//  CHMeetupApp
//
//  Created by Sam Mejlumyan on 02/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

extension String {
  var localized: String {
    return NSLocalizedString(self, comment: "")
  }
}
