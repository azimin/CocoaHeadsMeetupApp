//
//  UIViewController+FirstResponderRouter.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 27/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

private var swizzle: Void = {
  MethodSwizzler.swizzleMethods(objectClass: UIViewController.self,
                                originalSelector: #selector(UIViewController.viewWillAppear(_ :)),
                                swizzledSelector: #selector(UIViewController.ch_viewWillAppear(_ :)))
}()

extension UIViewController {
  class func swizzleFirstResponderRouter() {
    _ = swizzle
  }

  @objc
  func ch_viewWillAppear(_ animated: Bool) {
    ch_viewWillAppear(animated)

    if let router = router {
      RouterContainer.firstResponder = router
    }
  }
}
