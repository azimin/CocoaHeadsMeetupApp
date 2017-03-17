//
//  OptionTableViewCell.swift
//  CHMeetupApp
//
//  Created by Andrey Konstantinov on 16/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

final class OptionTableViewCell: PlateTableViewCell {

  @IBOutlet private var markImageView: UIImageView! {
    didSet {
      markImageView.image = OptionTableViewCell.image(selected: false)
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
    markImageView.image = OptionTableViewCell.image(selected: shouldSelect)
  }

  /// Preferable cell setup method
  func setup(data: OptionTableViewCellModel) {
    updateSelection(shouldSelect: data.selected)
    label.text = data.text
  }

}
