//
//  UIView+Template.swift
//  CHMeetupApp
//
//  Created by Dmitriy Lis on 15/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

extension UIView: TemplatableViewType {
  func apply(template: Bool) {
    for view in subviews {
      view.apply(template: template)
    }
  }
}
