//
//  UIColor+PaletteColors.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 08/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit.UIColor

extension UIColor {
  enum ColorType {
    case gray
    case darkGray
    case red
    case white
    case black
    case lightGray
    case pink
  }

  convenience init(_ colorType: ColorType) {
    switch colorType {
    case .gray:
      self.init(hexString: "8C8C8C")
    case .darkGray:
      self.init(hexString: "6C6C6C")
    case .red:
      self.init(hexString: "DB1D5F")
    case .white:
      self.init(hexString: "FDFEFE")
    case .black:
      self.init(hexString: "000000")
    case .lightGray:
      self.init(hexString: "E3E5E5")
    case .pink:
      self.init(hexString: "C550DC")
    }
  }
}
