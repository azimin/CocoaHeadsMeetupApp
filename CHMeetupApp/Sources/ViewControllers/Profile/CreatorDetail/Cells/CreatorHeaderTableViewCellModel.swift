//
//  CreatorHeaderTableViewCellModel.swift
//  CHMeetupApp
//
//  Created by Andrey Konstantinov on 01/07/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

struct CreatorHeaderTableViewCellModel {
  let creator: CreatorEntity
}

extension CreatorHeaderTableViewCellModel: CellViewModelType {
  func setup(on cell: CreatorHeaderTableViewCell) {
    cell.fullNameLabel.text = creator.name

    if let photoURL = creator.photoURL, let url = URL(string: photoURL) {
      cell.avatarImageView.loadImage(from: url)
    }

    cell.descriptionLabel.text = creator.url
  }
}
