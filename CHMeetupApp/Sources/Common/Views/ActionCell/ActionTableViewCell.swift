//
//  ActionTableViewCell.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 15/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class ActionTableViewCell: PlateTableViewCell {

  var isEnableForAction = false {
    didSet {
      enableImageView.isHidden = !isEnableForAction
    }
  }

  @IBOutlet var actionImageView: UIImageView! {
    didSet {
      actionImageView.isHidden = true
    }
  }
  @IBOutlet var enableImageView: UIImageView!

  @IBOutlet var descriptionActionLabel: UILabel! {
    didSet {
      descriptionActionLabel.font = UIFont.appFont(.gothamPro(size: 15))
      descriptionActionLabel.textColor = UIColor(.darkGray)
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    roundType = .all
  }
}
