//
//  ActionPlainObject.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 17/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

struct ActionPlainObject {
  var handler: String
  var imageName: String
  var isEnable = true

  init(handler: String, imageName: String) {
    self.handler = handler
    self.imageName = imageName
  }
}
