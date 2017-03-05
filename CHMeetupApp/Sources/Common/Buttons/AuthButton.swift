//
//  AuthButton.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 04/03/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class AuthButton: UIButton {

  var beforeColor: UIColor?

  override var isHighlighted: Bool {
    didSet {
      if oldValue != isHighlighted {
        updateStateAppearance()
      }
    }
  }

  override var isEnabled: Bool {
    didSet {
      if oldValue != isEnabled {
        updateStateAppearance()
      }
    }
  }

  override var isSelected: Bool {
    didSet {
      if oldValue != isSelected {
        updateStateAppearance()
      }
    }
  }

  func updateStateAppearance() {
    if beforeColor == nil {
      beforeColor = self.backgroundColor!
      self.backgroundColor = self.backgroundColor?.inTapped
    } else {
      self.backgroundColor = beforeColor
      beforeColor = nil
    }
  }

}
