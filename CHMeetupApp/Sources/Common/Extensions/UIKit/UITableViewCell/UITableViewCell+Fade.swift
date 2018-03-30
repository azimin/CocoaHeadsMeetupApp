//
//  UITableViewCell+Fade.swift
//  CHMeetupApp
//
//  Created by Dmitriy Lis on 27/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit.UITableViewCell

extension UITableViewCell {
  func animateWithFade() {
    alpha = 0.0
    UIView.animate(withDuration: 0.2, animations: {
      self.alpha = 1.0
    })
  }
}
