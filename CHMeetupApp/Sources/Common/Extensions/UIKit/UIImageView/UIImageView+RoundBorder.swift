//
//  UIImageView+RoundBorder.swift
//  CHMeetupApp
//
//  Created by Dmitriy Lis on 22/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit.UIImageView

extension UIImageView {
  func roundWithBorder(_ approximateBorderWidth: CGFloat, color: UIColor = .white) {
    let border = makeRoundBorder(approximateBorderWidth, color: color)
    roundCorners()
    shapeLayerBorder?.removeFromSuperlayer()
    shapeLayerBorder = border
    layer.addSublayer(border)
  }

  fileprivate func makeRoundBorder(_ approximateBorderWidth: CGFloat, color: UIColor) -> CAShapeLayer {
    let border = CAShapeLayer()
    border.strokeColor = color.cgColor
    border.fillColor = UIColor.clear.cgColor
    border.frame = bounds
    border.lineWidth = (approximateBorderWidth * 2).round(0.5)
    border.path = UIBezierPath(ovalIn: border.bounds).cgPath
    return border
  }
}
