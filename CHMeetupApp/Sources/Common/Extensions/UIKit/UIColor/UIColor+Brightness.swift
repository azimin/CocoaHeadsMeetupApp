//
//  UIColor+brightness.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 06/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

extension UIColor {

  var tapButtonChangeColor: UIColor {
    var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
    if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
      // Special formula
      if (red * 300 + green * 590 + blue * 115) / 1000 < 0.3 {
        return lighterColorForColor()
      }
    }
    return darkerColorForColor()
  }

  private func darkerColorForColor() -> UIColor {
    return changeColor(value: -0.2)
  }

  private func lighterColorForColor() -> UIColor {
    return changeColor(value: 0.2)
  }

  private func changeColor(value: CGFloat) -> UIColor {
    var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
    if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
      return UIColor(red: min(red + value, 1.0),
                     green: min(green + value, 1.0),
                     blue: min(blue + value, 1.0),
                     alpha: alpha)
    }
    return self
  }
}
