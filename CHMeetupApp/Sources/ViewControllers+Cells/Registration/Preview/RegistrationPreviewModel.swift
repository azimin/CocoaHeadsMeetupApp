//
//  RegistrationFieldModel.swift
//  CHMeetupApp
//
//  Created by Maxim Globak on 04.03.17.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation
import UIKit

protocol RegistrationFieldCellProtocol: ReusableCell {
  func setup(with item: FormFieldAnswer)
}

extension RegistrationFieldCellProtocol {
  static var identifier: String {
    return String(describing: self)
  }

  static var nib: UINib? {
    return UINib(nibName: String(describing: self), bundle: nil)
  }
}

class RegistrationFieldModel {

  var item: FormFieldAnswer

  init(with item: FormFieldAnswer) {
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

  func dequeueReusableCell(with item: FormFieldAnswer,
                           atIndexPath indexPath: IndexPath) -> UITableViewCell {

    let model = RegistrationFieldModel(with: item)
    let cellClass = model.cellClass()
    let cell = self.dequeueReusableCell(withIdentifier: cellClass.identifier, for: indexPath)

    if cell is RegistrationFieldCellProtocol {
      model.setup(on: (cell as? RegistrationFieldCellProtocol)!)
    }
    return cell
  }
}
