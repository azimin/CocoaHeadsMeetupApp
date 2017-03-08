//
//  TextFieldTableViewCell.swift
//  CHMeetupApp
//
//  Created by Maxim Globak on 04.03.17.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {

  @IBOutlet weak var textField: UITextField!

}

// MARK: - RegistrationFieldCellProtocol
extension TextFieldTableViewCell: RegistrationFieldCellProtocol {

  func setup(with item: FormFieldAnswer) {
    self.textField.placeholder = item.value
  }

  static var identifier: String {
    return String(describing: self)
  }

  static var nib: UINib? {
    return UINib(nibName: String(describing: self), bundle: nil)
  }
}
