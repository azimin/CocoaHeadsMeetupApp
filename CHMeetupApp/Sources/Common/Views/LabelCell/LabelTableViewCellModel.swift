//
//  LabelTableViewCellModel.swift
//  CHMeetupApp
//
//  Created by Sergey Zapuhlyak on 22/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

struct LabelTableViewCellModel {

  let title: String
  let info: String

}

extension LabelTableViewCellModel: CellViewModelType {

  func setup(on cell: LabelTableViewCell) {
    cell.setup(title: title, info: info)
  }

}
