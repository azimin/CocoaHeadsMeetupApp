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
  var isEnable: Bool
  var `isHidden`: Bool

  init(handler: String, imageName: String, isEnable: Bool, isHidden: Bool) {
    self.handler = handler
    self.imageName = imageName
    self.isEnable = isEnable
    self.isHidden = isHidden
  }
}
