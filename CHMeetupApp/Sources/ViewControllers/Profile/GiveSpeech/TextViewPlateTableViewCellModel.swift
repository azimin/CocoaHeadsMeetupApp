//
//  TextViewPlateTableViewCellModel.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 19/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

protocol TextViewPlateTableViewCellModelDelegate: class {
  func model(model: TextViewPlateTableViewCellModel, didLoadTextView textView: UITextView)
}

struct TextViewPlateTableViewCellModel {
  let value: String
  let placeholder: String
  let isEnabled: Bool
  weak var textViewDelegate: UITextViewDelegate?
  weak var delegate: TextViewPlateTableViewCellModelDelegate?
}

extension TextViewPlateTableViewCellModel: CellViewModelType {
  func setup(on cell: TextViewPlateTableViewCell) {
    cell.textView.text = value
    cell.textView.placeholder = placeholder
    cell.textView.delegate = textViewDelegate
    cell.textView.isEditable = isEnabled
    delegate?.model(model: self, didLoadTextView: cell.textView)
  }
}
