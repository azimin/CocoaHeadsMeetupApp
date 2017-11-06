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
    cell.descriptionActionLabel.text = action.text
    cell.isEnableForAction = action.action != nil

    if let imageName = action.imageName, let image = UIImage(named: imageName) {
      cell.actionImageView.image = action.isColorized ? image : image.imageWithTemplateRendingMode
      cell.actionImageView.isHidden = false
    } else {
      cell.actionImageView.isHidden = true
      cell.actionImageView.image = nil
    }

    if !action.isColorized {
      cell.actionImageView.tintColor = UIColor(.darkGray)
    }
  }

}
