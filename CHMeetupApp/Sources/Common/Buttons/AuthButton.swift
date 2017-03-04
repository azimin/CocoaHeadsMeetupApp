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

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    blur.frame = self.bounds
    self.insertSubview(blur, at: 0)
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    blur.removeFromSuperview()
  }
}
