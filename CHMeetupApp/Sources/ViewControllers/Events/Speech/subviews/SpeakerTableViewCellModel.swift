//
//  SpeakerTableViewCellModel.swift
//  CHMeetupApp
//
//  Created by Maxim Globak on 02.04.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

struct SpeakerTableViewCellModel {
  let speaker: UserEntity
}

extension SpeakerTableViewCellModel: CellViewModelType {
  func setup(on cell: SpeakerTableViewCell) {
    cell.fullNameLabel.text = speaker.fullName

    if let photoURL = speaker.photoURL, let url = URL(string: photoURL) {
      cell.avatarImageView.loadImage(from: url)
    }

    cell.descriptionLabel.attributedText =
    AttributedSentenceHelper.Preposition.at.concatString(firstPartString: speaker.position,
                                                         secondPartString: speaker.company)
  }
}
