//
//  SpeechPreviewTableViewCellModel.swift
//  CHMeetupApp
//
//  Created by Maxim Globak on 18.03.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

struct SpeechPreviewTableViewCellModel {

  // FIXME: - Uncomment next line with realm entity
  // let speachPreview: SpeachPreviewEntity

  var firstName: String
  var lastName: String
  var userPhoto: Data
  var topic: String
  var speachDescription: String
}

extension SpeechPreviewTableViewCellModel: CellViewModelType {
  func setup(on cell: SpeechPreviewTableViewCell) {

    cell.avatarImageView.image = UIImage(data: userPhoto)
    cell.fullNameLabel.text = firstName + " " + lastName
    cell.topicLabel.text = "«" + topic + "»"
    cell.speachDescriptionLabel.text = speachDescription
  }
}
