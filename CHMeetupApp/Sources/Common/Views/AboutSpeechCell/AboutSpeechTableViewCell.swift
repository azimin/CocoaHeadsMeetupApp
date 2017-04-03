//
//  AboutSpeechTableViewCell.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 29/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class AboutSpeechTableViewCell: PlateTableViewCell {

  @IBOutlet var infoLabel: UILabel! {
    didSet {
      infoLabel.font = UIFont.appFont(.gothamProMedium(size: 15))
      infoLabel.textColor = .lightGray
    }
  }
  @IBOutlet var titleLabel: UILabel! {
    didSet {
      titleLabel.font = UIFont.appFont(.gothamProMedium(size: 17))
      titleLabel.textColor = .black
    }
  }
  @IBOutlet var descriptionLabel: UILabel! {
    didSet {
      descriptionLabel.font = UIFont.appFont(.gothamPro(size: 17))
      descriptionLabel.textColor = .black
    }
  }
}
