//
//  EmailFormatter.swift
//  CHMeetupApp
//
//  Created by Dmitriy Lis on 23/07/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class EmailFormatter: FormatterType {
  var keyboardType: UIKeyboardType = .emailAddress

  func format(_ value: String) -> String {
    return value
  }
}
