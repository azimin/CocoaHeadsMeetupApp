//
//  TitleEventCell.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 28/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class InfoAboutEventTableViewCell: UITableViewCell {

  @IBOutlet var infoAboutEventLabel: UILabel!

  func configure(with event: EventPO) {
    infoAboutEventLabel.text = event.infoAboutEvent
  }

  static var nib: UINib {
    return UINib(nibName: String(describing: self), bundle: nil)
  }

  static var identifier: String {
    return String(describing: self)
  }
}
