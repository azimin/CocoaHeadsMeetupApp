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
  let validationType: StringValidation.ValidationType?

  weak var textFieldDelegate: UITextFieldDelegate?
  let valueChanged: (String) -> Void
}

extension EditableLabelTableViewModel: CellViewModelType {
  func setup(on cell: EditableLabelTableViewCell) {
    cell.descriptionTextField.text = description
    cell.descriptionTextField.placeholder = placeholder
    cell.descriptionTextField.delegate = textFieldDelegate

    if let type = self.validationType {
      switch type {
      case .phone:
        cell.descriptionTextField.keyboardType = .numberPad
      case .mail:
        cell.descriptionTextField.keyboardType = .emailAddress
      default: break
      }
    }
    cell.valueChanged = ({ sender in
      let senderText = sender.text ?? ""
      if let type = self.validationType, type == .phone {
        sender.text = PhoneNumberFormatter.format(number: senderText)
      }
      self.valueChanged(senderText)
    })
  }
}
