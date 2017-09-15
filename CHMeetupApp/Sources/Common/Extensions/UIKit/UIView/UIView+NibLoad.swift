//
//  UIView+NibLoad.swift
//  AZTabBarController
//
//  Created by Alex Zimin on 15/11/2016.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import UIKit

internal extension UIView {
  class func viewFromNib(withOwner owner: Any? = nil) -> Self {
    let name = String(describing: type(of: self)).components(separatedBy: ".")[0]
    let view = UINib(nibName: name, bundle: nil).instantiate(withOwner: owner, options: nil)[0]
    return cast(view)!
  }

  func loadFromNibIfEmbeddedInDifferentNib() -> Self {
    // based on: http://blog.yangmeyer.de/blog/2012/07/09/an-update-on-nested-nib-loading
    let isJustAPlaceholder = subviews.count == 0
    if isJustAPlaceholder {
      let theRealThing = type(of: self).viewFromNib()
      theRealThing.frame = frame
      translatesAutoresizingMaskIntoConstraints = false
      theRealThing.translatesAutoresizingMaskIntoConstraints = false
      return theRealThing
    }
    return self
  }
}

private func cast<T, U>(_ value: T) -> U? {
  return value as? U
}
