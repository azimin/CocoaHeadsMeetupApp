//
//  UIView+Shake.swift
//  CHMeetupApp
//
//  Created by Sam Mejlumyan on 15/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

extension UIView {
  func shake() {
    let shake: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
    shake.values = [NSValue(caTransform3D: CATransform3DMakeTranslation(-6.0, 0.0, 0.0)),
                    NSValue(caTransform3D: CATransform3DMakeTranslation(6.0, 0.0, 0.0))]
    shake.autoreverses = true
    shake.repeatCount = 2.0
    shake.duration = 0.07
    self.layer.add(shake, forKey: "shake")
  }
}
