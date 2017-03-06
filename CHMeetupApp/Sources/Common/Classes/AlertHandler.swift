//
//  AlarmHandler.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 06/03/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class AlertHandler {

  static func configure(title: String, message: String) -> UIAlertController {
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)

    let alert = UIAlertController(title: title.localized, message: message.localized, preferredStyle: .alert)
    alert.addAction(action)
    return alert
  }
}
