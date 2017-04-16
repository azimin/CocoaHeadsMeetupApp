//
//  UserTableViewHeaderCellModel.swift
//  CHMeetupApp
//
//  Created by Dmitriy Lis on 26/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

struct UserTableViewHeaderCellModel {
  let userEntity: UserEntity
}

extension UserTableViewHeaderCellModel: CellViewModelType {
  func setup(on cell: UserTableViewHeaderCell) {
    if let photoURL = userEntity.photoURL, let url = URL(string: photoURL) {
      cell.userImageView.loadImage(from: url)
    }
    cell.positionAtCompanyLabel.attributedText =
    AttributedSentenceHelper.Preposition.at.concatString(firstPartString: userEntity.position,
                                                         secondPartString: userEntity.company)
  }
}
