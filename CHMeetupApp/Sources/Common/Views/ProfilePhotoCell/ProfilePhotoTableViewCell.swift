//
//  ProfilePhotoTableViewCell.swift
//  CHMeetupApp
//
//  Created by Dmitriy Lis on 26/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class ProfilePhotoTableViewCell: UITableViewCell {

  @IBOutlet var positionAtCompanyLabel: UILabel!
  @IBOutlet var userImageView: UIImageView!

  override func layoutSubviews() {
    super.layoutSubviews()

    let borderWidth = userImageView.bounds.height * Constants.SystemSizes.imageViewBorderWidthPercentage
    userImageView.roundWithBorder(borderWidth)
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    contentView.backgroundColor = UIColor(.lightGray)
    selectionStyle = .none
  }
}
