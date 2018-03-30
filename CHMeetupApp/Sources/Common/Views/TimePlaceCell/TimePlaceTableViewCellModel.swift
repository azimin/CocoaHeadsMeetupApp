//
//  TimePlaceTableViewCellModel.swift
//  CHMeetupApp
//
//  Created by Dmitriy Lis on 20/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

struct TimePlaceTableViewCellModel {
  let event: EventEntity
}

extension TimePlaceTableViewCellModel: CellViewModelType {
  func setup(on cell: TimePlaceTableViewCell) {
    cell.timeLabel.text = event.startDate.defaultFormatString
    if let place = event.place {
      cell.placeLabel.text = place.city + ", " + place.title
    }
  }
}
