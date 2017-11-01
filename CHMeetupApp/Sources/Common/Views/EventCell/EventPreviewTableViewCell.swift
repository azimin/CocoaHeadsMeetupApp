//
//  EventPreviewTableViewCell.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 11/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

protocol EventPreviewTableViewCellDelegate: class {
  func eventCellAcceptButtonPressed(_ eventCell: EventPreviewTableViewCell)
}

class EventPreviewTableViewCell: PlateTableViewCell, TempalateView {

  var isTemplate: Bool = false {
    didSet {
      if !oldValue && isTemplate {
        animateWithFade()
      }
    }
  }

  var isEnabledForRegistration = false {
    didSet {
      goingButton.isHidden = !isEnabledForRegistration
    }
  }

  @IBOutlet var eventImageView: UIImageView!

  @IBOutlet var nameLabel: TemplatableLabel! {
    didSet {
      nameLabel.font = UIFont.appFont(.avenirNextMedium(size: 18))
      nameLabel.textColor = UIColor(.strongGray)
    }
  }

  @IBOutlet var dateLabel: TemplatableLabel! {
    didSet {
      dateLabel.font = UIFont.appFont(.avenirNextMedium(size: 16))
      dateLabel.textColor = UIColor(.strongGray)
    }
  }

  @IBOutlet var placeLabel: TemplatableLabel! {
    didSet {
      placeLabel.font = UIFont.appFont(.avenirNextMedium(size: 16))
      placeLabel.textColor = UIColor(.strongGray)
    }
  }

  @IBOutlet var separationView: UIView! {
    didSet {
      separationView.backgroundColor = UIColor(.lightGray)
    }
  }

  @IBOutlet var photosPresentationViewHeightConstraint: NSLayoutConstraint!

  @IBOutlet var photosPresentationViewTopConstraint: NSLayoutConstraint!

  @IBOutlet var photosPresentationView: PhotosPresentationView!

  @IBOutlet var goingButton: UIButton!

  override func awakeFromNib() {
    super.awakeFromNib()

    let traits = super.accessibilityTraits
    accessibilityTraits = traits | UIAccessibilityTraitButton

    photosPresentationView.delegate = self

    roundType = .all
  }

  weak var delegate: EventPreviewTableViewCellDelegate?

  var parcicipantsHeight: CGFloat {
    // 36 paricipant view height, 12 is space from top
    return 48
  }

  var goingButtonHeight: CGFloat {
    // Button with spaces height
    return 64
  }

  @IBAction fileprivate func goingButtonAction(_ sender: Any) {
    delegate?.eventCellAcceptButtonPressed(self)
  }

  // Now would calculate manually
  override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                        verticalFittingPriority: UILayoutPriority) -> CGSize {
    var height: CGFloat = 270

    if !isEnabledForRegistration {
      height -= goingButtonHeight
    }

    if photosPresentationView.photos.isEmpty {
      height -= parcicipantsHeight
      height -= separationView.frame.height
    }

    return CGSize(width: targetSize.width, height: height)
  }
}

extension EventPreviewTableViewCell: PhotosPresentationViewDelegate {
  func photosPresentationViewWillUpdateData(view: PhotosPresentationView) {
    if view.photos.isEmpty {
      separationView.isHidden = true
      photosPresentationViewHeightConstraint.constant = 0
      photosPresentationViewTopConstraint.constant = 0
    } else {
      photosPresentationViewHeightConstraint.constant = 36
      photosPresentationViewTopConstraint.constant = 12
    }
  }
}
