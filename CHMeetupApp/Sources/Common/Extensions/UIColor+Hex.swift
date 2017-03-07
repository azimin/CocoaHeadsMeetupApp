//
//  UIColor+Hex.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 08/03/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit.UIColor

extension UIColor {
  convenience init(hexString: String) {
    var hex = hexString

    if hex.hasPrefix("#") {
      hex = hex.substring(from: 1)
    }

    if hex.characters.count == 3 {
      let redHex = hex.substring(with: 0..<1)
      let greenHex = hex.substring(with: 1..<2)
      let blueHex = hex.substring(with: 2..<3)

      hex = redHex + redHex + greenHex + greenHex + blueHex + blueHex
    }

    let redHex = hex.substring(with: 0..<2)
    let greenHex = hex.substring(with: 2..<4)
    let blueHex = hex.substring(with: 4..<6)

    var redInt: CUnsignedInt = 0
    var greenInt: CUnsignedInt = 0
    var blueInt: CUnsignedInt = 0

    Scanner(string: redHex).scanHexInt32(&redInt)
    Scanner(string: greenHex).scanHexInt32(&greenInt)
    Scanner(string: blueHex).scanHexInt32(&blueInt)

    self.init(red: CGFloat(redInt) / 255.0,
              green: CGFloat(greenInt) / 255.0,
              blue: CGFloat(blueInt) / 255.0,
              alpha: 1.0)
  }
}
