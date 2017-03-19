//
//  EventPreviewTableViewCell.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 11/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class EventPreviewTableViewCell: PlateTableViewCell {

  var isEnabledForRegistration = false {
    didSet {
      goingButton.isHidden = !isEnabledForRegistration
    }
  }

  @IBOutlet var eventImageView: UIImageView!

  @IBOutlet var nameLabel: UILabel! {
    didSet {
      nameLabel.font = UIFont.appFont(.gothamPro(size: 17))
    }
  }

  @IBOutlet var dateLabel: UILabel! {
    didSet {
      dateLabel.font = UIFont.appFont(.gothamPro(size: 15))
    }
  }

  @IBOutlet var placeLabel: UILabel! {
    didSet {
      placeLabel.font = UIFont.appFont(.gothamPro(size: 15))
    }
  }

  @IBOutlet var separationView: UIView! {
    didSet {
      separationView.backgroundColor = UIColor(.lightGray)
    }
  }

  @IBOutlet var participantsCollectionView: ParticipantsCollectionView!

  @IBOutlet var goingButton: UIButton!

  override func awakeFromNib() {
    super.awakeFromNib()
    roundType = .all
  }

  // Now would calculate manually
  override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                        verticalFittingPriority: UILayoutPriority) -> CGSize {
    // 266 with button and 202 without
    return CGSize(width: targetSize.width, height: isEnabledForRegistration ? 266 : 202)
  }
}
