//
//  OptionTableViewCellModel.swift
//  CHMeetupApp
//
//  Created by Andrey Konstantinov on 16/03/17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

struct OptionTableViewCellModel {

  enum `Type` {
    case check
    case radio
  }

  let id: String
  let text: String
  let type: Type

}

extension OptionTableViewCellModel: CellViewModelType {

  func setup(on cell: OptionTableViewCell) {
    cell.setup(text: text, isRadio: type == .radio)
  }

}
