//
//  RegistrationFieldModel.swift
//  CHMeetupApp
//
//  Created by Maxim Globak on 04.03.17.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation
import UIKit

protocol RegistrationFieldCellProtocol {
  static var identifier: String { get }
  static var nib: UINib? { get }
  func setup(with item: RegistrationFieldItem)
}

class RegistrationFieldModel {

  var item: RegistrationFieldItem

  init(withItem item: RegistrationFieldItem) {
    self.item = item
  }

  func setup(on cell: RegistrationFieldCellProtocol) {
    cell.setup(with: item)
  }

  func cellClass() -> RegistrationFieldCellProtocol.Type {
    switch item.type {
    case .checkbox:
      return CheckboxTableViewCell.self
    case .radio:
      return RadioTableViewCell.self
    case .string:
      return TextFieldTableViewCell.self
    }
  }
}

extension UITableView {

  func dequeueReusableCell(withItem item: RegistrationFieldItem,
                           atIndexPath indexPath: IndexPath) -> UITableViewCell {

    let model = RegistrationFieldModel.init(withItem: item)
    let cellClass = model.cellClass()
    let cell = self.dequeueReusableCell(withIdentifier: cellClass.identifier, for: indexPath)

    if cell is RegistrationFieldCellProtocol {
      model.setup(on: (cell as? RegistrationFieldCellProtocol)!)
    }
    return cell
  }
}
