//
//  CreatorInfoTableViewCellModel.swift
//  CHMeetupApp
//
//  Created by Andrey Konstantinov on 01/07/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

struct CreatorInfoTableViewCellModel {
  let creator: CreatorEntity
}

extension CreatorInfoTableViewCellModel: CellViewModelType {
  func setup(on cell: CreatorInfoTableViewCell) {
    cell.descriptionLabel.text = creator.info
  }
}
