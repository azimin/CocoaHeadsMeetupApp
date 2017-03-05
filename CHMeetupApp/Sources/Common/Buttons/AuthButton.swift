//
//  AuthButton.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 04/03/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class AuthButton: UIButton {

  let blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))

  override var isHighlighted: Bool {
    didSet {
      if oldValue != isHighlighted {
        updateStateAppearance()
      }
    }
  }

  func updateStateAppearance() {
    if isHighlighted {
      blur.frame = self.bounds
      self.insertSubview(blur, at: 0)
    } else {
      blur.removeFromSuperview()
    }
  }

}
