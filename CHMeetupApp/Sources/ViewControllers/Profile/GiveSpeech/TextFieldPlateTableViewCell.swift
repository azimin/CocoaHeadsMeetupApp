//
//  TextFieldPlateTableViewCell.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 18/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class TextFieldPlateTableViewCell: PlateTableViewCell {
  @IBOutlet var textField: UITextField!

  var valueChanged: ((String) -> Void)?
  var returnPressed: ((String) -> Void)?

  @IBAction func textFieldTextChanged(_ sender: UITextField) {
    valueChanged?(sender.text ?? "")
  }
}
