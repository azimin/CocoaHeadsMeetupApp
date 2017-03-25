//
//  UITableView+Configure.swift
//  CHMeetupApp
//
//  Created by Michael Galperin on 25.03.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit.UITableView
import ObjectiveC

private var associationKey = "tableView_bottom_inset"
private var defaultBottomInsetValue: CGFloat = 8

extension UITableView {

  /// Set once and use to calculate inset when keyboard appears
  var defaultBottomInset: CGFloat {
    get {
      return (objc_getAssociatedObject(self, &associationKey) as? CGFloat) ?? defaultBottomInsetValue
    }
    set {
      contentInset.bottom = newValue
      objc_setAssociatedObject(self, &associationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
    }
  }

  func configure(
    estimatedRowHeight: CGFloat? = nil,
    rowHeight: CGFloat? = nil,
    backgroundColor: UIColor? = nil,
    leftInset: CGFloat? = nil,
    topInset: CGFloat? = nil,
    rightInset: CGFloat? = nil,
    bottomInset: CGFloat? = nil
  ) {
    let defaultEstimatedRowHeight: CGFloat = 100
    let defaultRowHeight = UITableViewAutomaticDimension
    let defaultBackgroundColor: UIColor = .clear

    let contentInset = UIEdgeInsets(
      top: topInset ?? 8,
      left: leftInset ?? 0,
      bottom: bottomInset ?? defaultBottomInsetValue,
      right: rightInset ?? 0
    )

    self.estimatedRowHeight = estimatedRowHeight ?? defaultEstimatedRowHeight
    self.rowHeight = rowHeight ?? defaultRowHeight
    self.backgroundColor = backgroundColor ?? defaultBackgroundColor
    self.contentInset = contentInset

    self.defaultBottomInset = bottomInset ?? defaultBottomInsetValue
  }

}
