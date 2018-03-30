//
//  ActionPlainObject.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 17/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

struct ActionPlainObject {
  var text: String
  var imageName: String?
  var action: (() -> Void)?
  var isColorized: Bool

  init(text: String, imageName: String? = nil, isColorized: Bool = false, action: (() -> Void)? = nil) {
    self.text = text
    self.imageName = imageName
    self.action = action
    self.isColorized = isColorized
  }
}
