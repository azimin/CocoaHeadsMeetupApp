//
//  RadioTableViewCell.swift
//  CHMeetupApp
//
//  Created by Andrey Konstantinov on 16/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

final class RadioTableViewCell: PlateTableViewCell {

  @IBOutlet private var markImageView: UIImageView! {
    didSet {
      markImageView.image = RadioTableViewCell.image(selected: false)
    }
  }

  @IBOutlet private var label: UILabel! {
    didSet {
      label.text = " "
      label.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)
      label.textColor = UIColor.init(.gray)
    }
  }

  class func image(selected: Bool) -> UIImage {
    let imageName = selected ? "img_radio_selected" : "img_radio_normal"
    return UIImage(named: imageName)!
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    updateSelection(shouldSelect: false)
  }

  override func updateSelection(shouldSelect: Bool) {
    label.textColor = shouldSelect ? UIColor.init(.black) : UIColor.init(.gray)
    markImageView.image = RadioTableViewCell.image(selected: shouldSelect)
  }

  /// Preferable cell setup method
  func setup(data: RadioTableViewCellModel) {
    updateSelection(shouldSelect: data.selected)
    label.text = data.text
  }

}
