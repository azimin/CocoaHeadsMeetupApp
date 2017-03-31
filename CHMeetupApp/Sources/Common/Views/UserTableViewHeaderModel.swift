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
    if let url = URL(string: userEntity.photoURL ?? "") {
      if let data = NSData(contentsOf: url) {
        cell.userImageView.image = UIImage(data: data as Data)
      }
    }

    let position = userEntity.position ?? ""
    let company = userEntity.company ?? ""

    let normalAttributes =
      [NSFontAttributeName: UIFont.appFont(.gothamPro(size: 17)),
       NSForegroundColorAttributeName: UIColor(.darkGray)]
    let atAttributes =
      [NSFontAttributeName: UIFont.appFont(.gothamPro(size: 17)),
       NSForegroundColorAttributeName: UIColor(.gray)]

    let attributedString = NSMutableAttributedString()
    attributedString.append(NSAttributedString(string: position, attributes: normalAttributes))
    if !position.isEmpty && !company.isEmpty {
      attributedString.append(NSAttributedString(string: " " + "at".localized + " ", attributes: atAttributes))
    }
    attributedString.append(NSAttributedString(string: company, attributes: normalAttributes))

    cell.positionAtCompanyLabel.attributedText = attributedString
  }
}
