//
//  UIColor+PaletteColors.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 08/03/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit.UIColor

extension UIColor {
  enum ColorType {
    case grey
    case red
  }

  @available(*, deprecated)
  static func appColor(_ colorType: ColorType) -> UIColor {
    switch colorType {
    case .grey:
      return UIColor(hexString: "8C8C8C")
    case .red:
      return UIColor(hexString: "DB1D5F")
    }
  }

  convenience init(_ colorType: ColorType) {
    switch colorType {
    case .grey:
      self.init(hexString: "8C8C8C")
    case .red:
      self.init(hexString: "DB1D5F")
    }
  }
}
