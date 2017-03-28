//
//  LabelTableViewCell.swift
//  CHMeetupApp
//
//  Created by Sergey Zapuhlyak on 22/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

final class LabelTableViewCell: PlateTableViewCell {

  @IBOutlet var titleLabel: UILabel! {
    didSet {
      titleLabel.numberOfLines = 0
      titleLabel.font = UIFont.appFont(.gothamProMedium(size: 15))
      titleLabel.textColor = UIColor(.gray)
    }
  }

  @IBOutlet var infoLabel: UILabel! {
    didSet {
      infoLabel.numberOfLines = 0
      infoLabel.font = UIFont.appFont(.gothamPro(size: 15))
      infoLabel.textColor = UIColor(.black)
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    roundType = .all
  }

}
