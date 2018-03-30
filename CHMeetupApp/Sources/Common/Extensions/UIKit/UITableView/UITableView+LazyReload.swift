//
//  UITableView+LazyReload.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 29/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

import UIKit

private var associationKey = "tableView_lazy_reload"

private var swizzle: Void = {
  MethodSwizzler.swizzleMethods(objectClass: UITableView.self,
                                originalSelector: #selector(UITableView.reloadData),
                                swizzledSelector: #selector(UITableView.ch_reloadData))
}()

// This interesting solution creating lazy reload for table view
extension UITableView {
  static func swizzleForLazyReload() {
    _ = swizzle
  }

  // for swizzle we would use prefix to avoid problems
  @objc
  fileprivate func ch_reloadData() {
    if isReloadInProgress {
      return
    }

    isReloadInProgress = true
    OperationQueue.main.addOperation {
      self.ch_reloadData()
      self.isReloadInProgress = false
    }
  }

  func reloadDataImmediately() {
    ch_reloadData()
  }

  private var isReloadInProgress: Bool {
    get {
      return (objc_getAssociatedObject(self, &associationKey) as? Bool) ?? false
    }
    set {
      objc_setAssociatedObject(self, &associationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
    }
  }
}
