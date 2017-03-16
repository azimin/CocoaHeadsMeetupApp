//
//  RadioTableViewCellModel.swift
//  CHMeetupApp
//
//  Created by Andrey Konstantinov on 16/03/17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

struct RadioTableViewCellModel {
  let id: String
  let text: String
  var selected: Bool
}

extension RadioTableViewCellModel: CellViewModelType {

  func setup(on cell: RadioTableViewCell) {
    cell.setup(data: self)
  }

}
