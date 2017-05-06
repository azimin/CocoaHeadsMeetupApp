//
//  TextFieldPlateTableViewCellModel.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 18/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

struct TextFieldPlateTableViewCellModel {
  let value: String
  let placeholder: String
  let keyboardType: UIKeyboardType
  weak var textFieldDelegate: UITextFieldDelegate?
  let valueChanged: ((String) -> Void)
}

extension TextFieldPlateTableViewCellModel: CellViewModelType {
  func setup(on cell: TextFieldPlateTableViewCell) {
    cell.textField.placeholder = placeholder
    cell.textField.delegate = textFieldDelegate
    cell.textField.text = value
    cell.textField.keyboardType = keyboardType
    cell.valueChanged = valueChanged
  }
}
