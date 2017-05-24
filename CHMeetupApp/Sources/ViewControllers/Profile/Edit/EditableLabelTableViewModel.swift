//
//  EditableLabelTableViewModel.swift
//  CHMeetupApp
//
//  Created by Dmitriy Lis on 02/05/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

struct EditableLabelTableViewModel {
  let description: String
  let placeholder: String
  weak var textFieldDelegate: UITextFieldDelegate?
  let returnKeyType: UIReturnKeyType
  let keyboardType: UIKeyboardType
  let valueChanged: ((String) -> Void)
}

extension EditableLabelTableViewModel: CellViewModelType {
  func setup(on cell: EditableLabelTableViewCell) {
    cell.descriptionTextField.text = description
    cell.descriptionTextField.placeholder = placeholder
    cell.descriptionTextField.delegate = textFieldDelegate
    cell.descriptionTextField.keyboardType = keyboardType
    cell.descriptionTextField.returnKeyType = returnKeyType
    cell.valueChanged = valueChanged
  }
}
