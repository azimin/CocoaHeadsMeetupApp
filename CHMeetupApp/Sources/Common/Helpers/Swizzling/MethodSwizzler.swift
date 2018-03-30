//
//  MethodSwizzler.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 11/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

struct MethodSwizzler {
  static func swizzleMethods(objectClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
    guard let originalMethod = class_getInstanceMethod(objectClass, originalSelector),
      let swizzledMethod = class_getInstanceMethod(objectClass, swizzledSelector) else { return }
    let methodAdded = class_addMethod(objectClass,
                                      originalSelector,
                                      method_getImplementation(swizzledMethod),
                                      method_getTypeEncoding(swizzledMethod))
    if methodAdded {
      class_replaceMethod(objectClass,
                          swizzledSelector,
                          method_getImplementation(originalMethod),
                          method_getTypeEncoding(originalMethod))
    } else {
      method_exchangeImplementations(originalMethod, swizzledMethod)
    }
  }
}
