//
//  UITableViewCell+ReusableCell.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 09/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit.UITableViewCell

extension UITableViewCell: ReusableCell {
  static var identifier: String {
    return String(describing: self)
  }

  static var nib: UINib {
    return UINib(nibName: identifier, bundle: nil)
  }
}
