//
//  EditableLabelTableViewCell.swift
//  CHMeetupApp
//
//  Created by Dmitriy Lis on 02/05/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class EditableLabelTableViewCell: PlateTableViewCell {

  @IBOutlet var descriptionTextField: UITextField! {
    didSet {
      descriptionTextField.font = UIFont.appFont(.avenirNextDemiBold(size: 16))
      descriptionTextField.textColor = UIColor(.black)
      descriptionTextField.returnKeyType = .done
      descriptionTextField.autocorrectionType = .no
    }
  }

  var valueChanged: ((String) -> Void)?

  override func awakeFromNib() {
    super.awakeFromNib()
    roundType = .all
  }

  @IBAction func descriptionTextViewChanged(_ sender: UITextField) {
    valueChanged?(sender.text ?? "")
  }
}
