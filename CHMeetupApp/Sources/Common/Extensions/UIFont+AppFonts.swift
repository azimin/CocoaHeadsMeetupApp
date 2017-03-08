//
//  UIFont+AppFonts.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 08/03/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit.UIFont

extension UIFont {
  enum FontType {
    case gothamProMedium(size: CGFloat)
    case systemFont(size: CGFloat)
  }

  static func appFont(_ fontType: FontType) -> UIFont {
    switch fontType {
    case .gothamProMedium(let size):
      return UIFont(name: "GothamPro-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    case .systemFont(let size):
      return UIFont.systemFont(ofSize: size)
    }
  }
}
