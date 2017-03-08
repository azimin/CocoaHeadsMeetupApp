//
//  CheckboxTableViewCell.swift
//  CHMeetupApp
//
//  Created by Maxim Globak on 08.03.17.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class CheckboxTableViewCell: UITableViewCell {

  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var button: UIButton!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }

  @IBAction func buttonPressed(_ sender: UIButton) {
  }
}

// MARK: - RegistrationFieldCellProtocol
extension CheckboxTableViewCell: RegistrationFieldCellProtocol {
  func setup(with item: RegistrationFieldItem) {
    label.text = item.name
  }

  static var identifier: String {
    return String(describing: self)
  }

  static var nib: UINib? {
    return UINib(nibName: String(describing: self), bundle: nil)
  }
}
