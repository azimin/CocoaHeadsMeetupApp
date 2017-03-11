//
//  EventPreviewTableViewCellModel.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 11/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

struct EventPreviewTableViewCellModel: CellViewModelType {
  let event: EventEntity

  func setup(on cell: EventPreviewTableViewCell) {
    cell.eventImageView.image = #imageLiteral(resourceName: "img_event_template")
    cell.nameLabel.text = event.title
    cell.dateLabel.text = "01.02.2017"
    // FIXME: - Right date
    if let place = event.place {
      cell.placeLabel.text = place.city + ", " + place.title
    }


    cell.isEnableForRegistration = true
  }
}
