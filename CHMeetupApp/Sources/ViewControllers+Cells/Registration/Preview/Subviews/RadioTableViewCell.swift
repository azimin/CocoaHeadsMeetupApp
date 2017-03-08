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

  @IBAction func buttonPressed(_ sender: UIButton) {
  }
}

// MARK: - RegistrationFieldCellProtocol
extension RadioTableViewCell: RegistrationFieldCellProtocol {
  func setup(with item: FormFieldAnswer) {
    label.text = item.value
  }
}
