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
  let isFirst: Bool
  let isLast: Bool

  init(id: String, text: String, type: Type, isFirst: Bool, isLast: Bool) {
    self.id = id
    self.text = text
    self.type = type
    self.isFirst = isFirst
    self.isLast = isLast
  }

}

extension OptionTableViewCellModel: CellViewModelType {

  func setup(on cell: OptionTableViewCell) {
    let roundType: PlateTableViewCell.RoundType = {
      if isFirst && isLast {
        return .all
      }
      if isFirst {
        return .top
      }
      if isLast {
        return .bottom
      }
      return .none
    }()
    cell.setup(data: self, roundType: roundType)
  }

}

// FIXME: - Delete

struct OptionsDisplayCollection: DisplayCollection, DisplayCollectionAction {

  var modelCollection = [[OptionTableViewCellModel]]()

  var numberOfSections: Int {
    return modelCollection.count
  }

  func numberOfRows(in section: Int) -> Int {
    return modelCollection[section].count
  }

  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
    return modelCollection[indexPath.section][indexPath.row]
  }

  func didSelect(indexPath: IndexPath) {
    print("tap")
  }
}
