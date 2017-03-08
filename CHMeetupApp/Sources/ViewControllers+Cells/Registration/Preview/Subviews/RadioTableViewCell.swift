//
//  RadioTableViewCell.swift
//  CHMeetupApp
//
//  Created by Maxim Globak on 08.03.17.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class RadioTableViewCell: UITableViewCell {

  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var button: UIButton!

  var buttonActionBlock = { () -> Void in }

  @IBAction func buttonPressed(_ sender: UIButton) {
    buttonActionBlock()
  }
}

// MARK: - RegistrationFieldCellProtocol
extension RadioTableViewCell: RegistrationFieldCellProtocol {
  func setup(with item: FormFieldAnswer) {
    label.text = item.value
    buttonActionBlock = {
      print("click \(item.value)")
    }
  }
}
