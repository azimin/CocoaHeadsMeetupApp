//
//  SpeechPreviewTableViewCell.swift
//  CHMeetupApp
//
//  Created by Maxim Globak on 17.03.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class SpeechPreviewTableViewCell: PlateTableViewCell {

  @IBOutlet var avatarImageView: UIImageView! {
    didSet {
      avatarImageView.layer.cornerRadius = avatarImageView.bounds.size.height / 2
      avatarImageView.backgroundColor = UIColor(.lightGray)
    }
  }

  @IBOutlet var fullNameLabel: UILabel! {
    didSet {
      fullNameLabel.font = UIFont.appFont(.gothamProMedium(size: 16))
      fullNameLabel.textColor = UIColor(.black)
    }
  }

  @IBOutlet var topicLabel: UILabel! {
    didSet {
      topicLabel.font = UIFont.appFont(.systemFont(size: 17))
      topicLabel.textColor = UIColor(.black)
    }
  }

  @IBOutlet var seporatorLineView: UIView! {
    didSet {
      seporatorLineView.backgroundColor = UIColor(.lightGray)
    }
  }

  @IBOutlet var speachDescriptionLabel: UILabel! {
    didSet {
      speachDescriptionLabel.font = UIFont.appFont(.systemFont(size: 15))
      speachDescriptionLabel.textColor = UIColor(.darkGray)
      speachDescriptionLabel.numberOfLines = 3
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    roundType = .all
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    // Rounded avatar image
    avatarImageView.layer.cornerRadius = avatarImageView.bounds.size.height / 2
  }
}
