//
//  ActionButtonTableViewCell.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 04/03/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class ActionButtonTableViewCell: UITableViewCell {

  @IBAction func buttonWasTupped( sender: UIButton) {
    actionByTap?(self)
  }
  var actionByTap: ((ActionButtonTableViewCell) -> Void)?
}
