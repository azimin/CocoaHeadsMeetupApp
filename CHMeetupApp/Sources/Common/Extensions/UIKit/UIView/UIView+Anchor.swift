//
//  UIView+Anchor.swift
//  CHMeetupApp
//
//  Created by Michael Galperin on 28.02.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

/// Autolayout helper

extension UIView {

  /// By sides with constants
  func anchor(
      leading: NSLayoutXAxisAnchor? = nil,
      top: NSLayoutYAxisAnchor? = nil,
      trailing: NSLayoutXAxisAnchor? = nil,
      bottom: NSLayoutYAxisAnchor? = nil,
      leadingConstant: CGFloat = 0,
      topConstant: CGFloat = 0,
      trailingConstant: CGFloat = 0,
      bottomConstant: CGFloat = 0,
      heightConstant: CGFloat = 0,
      widthConstant: CGFloat = 0
    ) {

    translatesAutoresizingMaskIntoConstraints = false

    if let leading = leading {
      leadingAnchor.constraint(equalTo: leading, constant: leadingConstant).isActive = true
    }
    if let top = top {
      topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
    }
    if let trailing = trailing {
      trailingAnchor.constraint(equalTo: trailing, constant: trailingConstant).isActive = true
    }
    if let bottom = bottom {
      bottomAnchor.constraint(equalTo: bottom, constant: bottomConstant).isActive = true
    }
    if heightConstant != 0 {
      heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
    }
    if widthConstant != 0 {
      widthAnchor.constraint(equalToConstant: widthConstant).isActive = true
    }
  }

  /// By vertical & horizontal alignment
  func anchor(
      centerX: NSLayoutXAxisAnchor? = nil,
      centerY: NSLayoutYAxisAnchor? = nil) {
    translatesAutoresizingMaskIntoConstraints = false

    if let centerX = centerX {
      centerXAnchor.constraint(equalTo: centerX).isActive = true
    }
    if let centerY = centerY {
      centerYAnchor.constraint(equalTo: centerY).isActive = true
    }
  }

  /// By its sizes with multipliers
  func anchor(
      widthAnchor: NSLayoutDimension? = nil,
      heightAnchor: NSLayoutDimension? = nil,
      widthMultiplier: CGFloat = 1,
      heightMultiplier: CGFloat = 1) {
    translatesAutoresizingMaskIntoConstraints = false

    if let width = widthAnchor {
      self.widthAnchor.constraint(equalTo: width, multiplier: widthMultiplier).isActive = true
    }
    if let height = heightAnchor {
      self.heightAnchor.constraint(equalTo: height, multiplier: heightMultiplier).isActive = true
    }
  }

  /// Pin to all 4 sides
  func anchorToAllSides(of view: UIView) {
    self.anchor(
      leading: view.leftAnchor,
      top: view.topAnchor,
      trailing: view.rightAnchor,
      bottom: view.bottomAnchor
    )
  }

}
