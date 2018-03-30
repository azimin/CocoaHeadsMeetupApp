//
//  SwizzlingController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 28/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

struct SwizzlingController {
  static func swizzleMethods() {
    UINavigationItem.swizzleForTitleConfugation()
    UITableView.swizzleForLazyReload()
  }
}
