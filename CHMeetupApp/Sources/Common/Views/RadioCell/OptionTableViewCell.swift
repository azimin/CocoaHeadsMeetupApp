//
//  OptionTableViewCell.swift
//  CHMeetupApp
//
//  Created by Andrey Konstantinov on 16/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

final class OptionTableViewCell: PlateTableViewCell {

  @IBOutlet private var markImageView: UIImageView!

  @IBOutlet private var label: UILabel! {
    didSet {
      label.numberOfLines = 0
      label.font = UIFont.appFont(.systemMediumFont(size: 15))
      label.textColor = UIColor(.gray)
      label.text = " "
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    shouldHaveVerticalMargin = false
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    updateSelection(shouldSelect: false)
  }

  override func updateSelection(shouldSelect: Bool) {
    label.textColor = shouldSelect ? UIColor(.black) : UIColor(.gray)
    markImageView.isHighlighted = shouldSelect
  }

  /// Preferable cell setup method
  func setup(text: String, isRadio: Bool) {
    label.text = text
    markImageView.image = image(selected: false, isRadio: isRadio)
    markImageView.highlightedImage = image(selected: true, isRadio: isRadio)
  }

  // MARK: - Private

  private func image(selected: Bool, isRadio: Bool) -> UIImage {
    let radioImage = selected ? "img_radio_selected" : "img_radio_normal"
    let checkImage = selected ? "img_check_selected" : "img_check_normal"
    let imageName = isRadio ? radioImage : checkImage
    return UIImage(named: imageName)!
  }

}
