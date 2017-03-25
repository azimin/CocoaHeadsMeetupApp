//
//  ActionTableViewCellModel.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 16/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

struct ActionTableViewCellModel {
  let action: ActionPlainObject
}

extension ActionTableViewCellModel: CellViewModelType {
  func setup(on cell: ActionTableViewCell) {
    cell.descriptionActionLabel.text = action.handler

    if action.imageName != "" {
      cell.actionImageView.isHidden = false
      cell.actionImageView.image = UIImage(named: action.imageName)
    }
  }
}
