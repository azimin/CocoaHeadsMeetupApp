//
//  AddressButtonTableViewCell.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 05/03/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class AddressButtonTableViewCell: ActionButtonTableViewCell {

  @IBAction func showAddress(_ sender: UIButton) {
  }

  static var nib: UINib {
    return UINib(nibName: String(describing: self), bundle: nil)
  }

  static var identifier: String {
    return String(describing: self)
  }
}
