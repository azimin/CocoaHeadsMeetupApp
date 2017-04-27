//
//  UIViewController+StaticRouterCheck.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 27/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

private var swizzle: Void = {
  MethodSwizzler.swizzleMethods(objectClass: UIViewController.self,
                                originalSelector: #selector(UIViewController.viewDidAppear(_:)),
                                swizzledSelector: #selector(UIViewController.ch_viewDidAppear(_:)))
}()

extension UIViewController {
  class func swizzleStaticRouterAnalyzer() {
    _ = swizzle
  }

  @objc
  func ch_viewDidAppear(_ animated: Bool) {
    ch_viewWillAppear(animated)

    // Check if router should be ignored
    if self is RouterIgnorable {
      return
    }

    let name = NSStringFromClass(type(of: self))
    let moduleName = name.components(separatedBy: ".").first ?? ""

    // Check if module is right
    if moduleName != "CHMeetupApp" {
      return
    }

    if router == nil {
      assertionFailure("Must have router")
    }
  }
}
