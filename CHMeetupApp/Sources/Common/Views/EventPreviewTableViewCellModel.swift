//
//  EventPreviewTableViewCellModel.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 11/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

struct EventPreviewTableViewCellModel {
  let event: EventEntity
  let index: Int
  let participantsImageNames: [String] = ["img_photo_participant-alex",
                                          "img_photo_participant-sam",
                                          "img_photo_participant-misha",
                                          "img_photo_participant-max",
                                          "img_photo_participant-kirill",
                                          "img_photo_participant-egor",
                                          "img_photo_participant-dima"]
}

extension EventPreviewTableViewCellModel: CellViewModelType {
  func setup(on cell: EventPreviewTableViewCell) {
    cell.eventImageView.image = #imageLiteral(resourceName: "img_event_template")
    cell.nameLabel.text = event.title
    cell.dateLabel.text = event.startDate.defaultFormatString

    if let place = event.place {
      cell.placeLabel.text = place.city + ", " + place.title
    }

    cell.isEnabledForRegistration = (event.startDate.isPassed == false)

    var images: [UIImage] = []
    for index in 0..<min((index + 1), participantsImageNames.count) {
      images.append(UIImage(named: participantsImageNames[index])!)
    }
    cell.participantsCollectionView.imagesCollection = images
  }
}
