//
//  TitleEventCell.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 28/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class TitleEventCell: UITableViewCell {

  @IBOutlet weak var titleEventLabel: UILabel!

  func configure(with: InfoAboutEvent) {
    titleEventLabel.text = with.title
  }

  static var nib: UINib {
    return UINib(nibName: String(describing: self), bundle: nil)
  }

  static var identifier: String {
    return String(describing: self)
  }
}
