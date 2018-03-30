//
//  Optional+Empty.swift
//  CHMeetupApp
//
//  Created by Dmitriy Lis on 08/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
  var ifNotEmpty: String? {
    if let value = self, !value.isEmpty {
      return value
    }
    return nil
  }
}
