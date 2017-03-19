//
//  TextViewPlateTableViewCellModel.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 19/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

struct TextViewPlateTableViewCellModel {
  let placeholder: String
  weak var textViewDelegate: UITextViewDelegate?
  var setupTextView: (UITextView) -> Void
}

extension TextViewPlateTableViewCellModel: CellViewModelType {
  func setup(on cell: TextViewPlateTableViewCell) {
    cell.textView.placeholder = placeholder
    cell.textView.delegate = textViewDelegate
    setupTextView(cell.textView)
  }
}
