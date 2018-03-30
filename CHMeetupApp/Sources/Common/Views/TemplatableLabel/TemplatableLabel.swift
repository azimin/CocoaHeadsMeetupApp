//
//  TemplatableLabel.swift
//  CHMeetupApp
//
//  Created by Dmitriy Lis on 25/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class ShineLayer: CALayer {
  func shine() {
    let gradient = CAGradientLayer()
    gradient.startPoint = CGPoint(x: 0, y: 0)
    gradient.endPoint = CGPoint(x: 1, y: -0.02)
    gradient.frame = CGRect(x: 0, y: 0, width: bounds.size.width * 2, height: bounds.size.height)

    let solid = UIColor(white: 1, alpha: 0.7).cgColor
    let clear = UIColor(white: 1, alpha: 0.0).cgColor
    gradient.colors = [clear, solid, clear]

    let theAnimation = CABasicAnimation(keyPath: "transform.translation.x")
    theAnimation.duration = 2
    theAnimation.repeatCount = Float.infinity
    theAnimation.autoreverses = true
    theAnimation.fillMode = kCAFillModeForwards
    theAnimation.fromValue = -frame.size.width
    theAnimation.toValue = 0
    gradient.add(theAnimation, forKey: "animateLayer")

    self.addSublayer(gradient)
  }
}

class TemplatableLabel: UILabel, TempalateView {

  var isTemplate: Bool = true {
    didSet {
      if oldValue == true && isTemplate == false {
        animationLayers.forEach({ $0.removeFromSuperlayer() })
      }
      setNeedsDisplay()
    }
  }
  private var animationLayers: [CALayer] = []

  override func draw(_ rect: CGRect) {
    guard isTemplate else {
      super.draw(rect)
      return
    }

    self.drawLoadingLayers()
  }

  private func drawLoadingLayers() {
    animationLayers.forEach({ $0.removeFromSuperlayer() })

    let lineHeight = font.lineHeight
    let numberOfLines = Int(round(frame.height / lineHeight))
    let numberOfSpaces = numberOfLines * 2
    let space = frame.height / CGFloat(numberOfSpaces)

    for i in 0..<numberOfLines {
      var frame = CGRect(x: 0, y: CGFloat(i) * 2 * space + space / 2, width: bounds.width, height: space)

      if i > 0 && i == (numberOfLines - 1) {
        frame.size.width = frame.width / 2
      }

      let layer = ShineLayer()
      layer.backgroundColor = UIColor(.gray).cgColor
      layer.frame = frame
      layer.opacity = 0.5
      layer.masksToBounds = true
      layer.shine()

      self.layer.addSublayer(layer)
      animationLayers.append(layer)
    }
  }
}
