//
//  CreatorHeaderTableViewCell.swift
//  CHMeetupApp
//
//  Created by Andrey Konstantinov on 01/07/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

final class CreatorHeaderTableViewCell: PlateTableViewCell {

  @IBOutlet var avatarImageView: UIImageView! {
    didSet {
      avatarImageView.backgroundColor = UIColor(.darkGray)
      avatarImageView.clipsToBounds = true
    }
  }

  @IBOutlet var fullNameLabel: UILabel! {
    didSet {
      fullNameLabel.font = UIFont.appFont(.avenirNextDemiBold(size: 18))
      fullNameLabel.textColor = UIColor(.darkGray)
    }
  }

  @IBOutlet var descriptionLabel: UILabel! {
    didSet {
      descriptionLabel.font = UIFont.appFont(.avenirNextMedium(size: 16))
      descriptionLabel.textColor = UIColor(.darkGray)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    avatarImageView.roundCorners()
  }
}
