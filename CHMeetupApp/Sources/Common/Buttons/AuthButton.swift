//
//  AuthButton.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 04/03/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class AuthButton: UIButton {

  var beforeColor = UIColor()

  override var isHighlighted: Bool {
    didSet {
      if oldValue != isHighlighted {
        updateStateAppearance()
      }
    }
  }

  func updateStateAppearance() {
    if isHighlighted {
      beforeColor = self.backgroundColor!
      self.backgroundColor = self.backgroundColor?.inTapped
    } else {
      self.backgroundColor = beforeColor
    }
  }

}
