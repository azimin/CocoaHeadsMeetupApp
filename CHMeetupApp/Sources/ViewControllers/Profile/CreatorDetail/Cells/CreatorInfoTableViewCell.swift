//
//  CreatorInfoTableViewCell.swift
//  CHMeetupApp
//
//  Created by Andrey Konstantinov on 01/07/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

final class CreatorInfoTableViewCell: PlateTableViewCell {

  @IBOutlet var descriptionLabel: UILabel! {
    didSet {
      descriptionLabel.font = UIFont.appFont(.avenirNextMedium(size: 16))
      descriptionLabel.textColor = .black
    }
  }

}
