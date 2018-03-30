//
//  ShadowViewAppearance.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 12/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

@objc
class ShadowViewAppearance: NSObject {
  var shadowOpacity: Float
  var shadowColor: UIColor
  var shadowRadius: CGFloat

  init(shadowOpacity: Float, shadowColor: UIColor, shadowRadius: CGFloat) {
    self.shadowOpacity = shadowOpacity
    self.shadowColor = shadowColor
    self.shadowRadius = shadowRadius
  }
}
