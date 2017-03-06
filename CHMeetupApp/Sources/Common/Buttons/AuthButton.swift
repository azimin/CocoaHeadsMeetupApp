//
//  AuthButton.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 04/03/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class AuthButton: UIButton {

  override var isHighlighted: Bool {
    didSet {
      if oldValue != isHighlighted {
        if let color = self.backgroundColor {
          self.backgroundColor = (isHighlighted ? color.darkerTap : color.lighterTap)
        }
      }
    }
  }

  override var isEnabled: Bool {
    didSet {
      if oldValue != isEnabled {
        if let color = self.backgroundColor {
          self.backgroundColor = (isEnabled ? color.lighterTap : color.darkerTap)
        }
      }
    }
  }

  override var isSelected: Bool {
    didSet {
      if oldValue != isSelected {
        if let color = self.backgroundColor {
          self.backgroundColor = (isSelected ? color.darkerTap : color.lighterTap)
        }
      }
    }
  }

}
