//
//  UITableView+Configure.swift
//  CHMeetupApp
//
//  Created by Michael Galperin on 29.03.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit.UITableView
import ObjectiveC

private var associationKey = "tableView_bottom_inset"

struct TableViewConfiguration {
  var topInset: CGFloat?
  var bottomInset: CGFloat?
  var bottomIndicatorInset: CGFloat?
  var estimatedRowHeight: CGFloat
  var rowHeight: CGFloat
  var backgroundColor: UIColor

  /// Tricky necessity of struct initializer.
  /// Without it when initializing you have to pass all existing parameters for correct type matching
  init(
    topInset: CGFloat? = nil,
    bottomInset: CGFloat? = nil,
    bottomIndicatorInset: CGFloat? = nil,
    estimatedRowHeight: CGFloat = 0,
    rowHeight: CGFloat = UITableViewAutomaticDimension,
    backgroundColor: UIColor = UIColor(.lightGray)
  ) {
    self.topInset = topInset
    self.bottomInset = bottomInset
    self.estimatedRowHeight = estimatedRowHeight
    self.bottomIndicatorInset = bottomIndicatorInset
    self.rowHeight = rowHeight
    self.backgroundColor = backgroundColor
  }

  static var `default` = defaultConfiguration
}

private var defaultConfiguration: TableViewConfiguration {
  return TableViewConfiguration(
    topInset: 8,
    bottomInset: 8,
    estimatedRowHeight: 100,
    rowHeight: UITableViewAutomaticDimension
  )
}

extension UITableView {

  private(set) var defaultBottomInset: CGFloat {
    get {
      return (objc_getAssociatedObject(self, &associationKey) as? CGFloat) ?? defaultConfiguration.bottomInset!
    }
    set {
      objc_setAssociatedObject(self, &associationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
    }
  }

  enum ConfigurationType {
    case defaultConfiguration
    case custom(TableViewConfiguration)
  }

  func configure(with configuration: ConfigurationType) {
    switch configuration {
    case .defaultConfiguration:
      setup(configuration: defaultConfiguration)
    case let .custom(customConfig):
      setup(configuration: customConfig)
    }
  }

  private func setup(configuration: TableViewConfiguration) {
    if let topInset = configuration.topInset {
      self.contentInset.top = topInset
    }
    if let bottomInset = configuration.bottomInset {
      self.contentInset.bottom = bottomInset
      defaultBottomInset = bottomInset
    }
    if let bottomIndicatorInset = configuration.bottomIndicatorInset {
      self.scrollIndicatorInsets.bottom = bottomIndicatorInset
    }

    self.estimatedRowHeight = configuration.estimatedRowHeight
    self.rowHeight = configuration.rowHeight

    self.backgroundColor = configuration.backgroundColor
  }

}
