//
//  SwitchActionPlainObject.swift
//  CHMeetupApp
//
//  Created by Chingis Gomboev on 20/03/2018.
//  Copyright © 2018 CocoaHeads Community. All rights reserved.
//

import Foundation

struct SwitchActionPlainObject {
  var text: String
  var imageName: String?
  var selectAction: (() -> Void)?
  var switchAction: ((Bool) -> Void)?
  var isOn: Bool

  init(text: String, imageName: String? = nil,
       isOn: Bool,
       selectAction: (() -> Void)? = nil,
       switchAction: ((Bool) -> Void)? = nil) {
    self.text = text
    self.imageName = imageName
    self.selectAction = selectAction
    self.switchAction = switchAction
    self.isOn = isOn
  }
}
