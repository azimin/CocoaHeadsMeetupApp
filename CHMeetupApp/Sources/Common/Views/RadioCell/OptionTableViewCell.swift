//
//  OptionTableViewCell.swift
//  CHMeetupApp
//
//  Created by Andrey Konstantinov on 16/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

final class OptionTableViewCell: PlateTableViewCell {

  private var isRadio = false

  @IBOutlet private var markImageView: UIImageView!

  @IBOutlet private var label: UILabel! {
    didSet {
      label.text = " "
      label.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)
      label.textColor = UIColor.init(.gray)
    }
  }

  @IBOutlet private var radioWidthContraint: NSLayoutConstraint!
  @IBOutlet private var checkWidthContraint: NSLayoutConstraint!

  override func awakeFromNib() {
    super.awakeFromNib()
    shouldHaveVerticalMargin = false
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    isRadio = false
    updateSelection(shouldSelect: false)
  }

  override func updateSelection(shouldSelect: Bool) {
    label.textColor = shouldSelect ? UIColor.init(.black) : UIColor.init(.gray)
    markImageView.image = image(selected: shouldSelect, isRadio: isRadio)
  }

  /// Preferable cell setup method
  func setup(data: OptionTableViewCellModel, roundType: RoundType) {
    label.text = data.text
    self.roundType = roundType

    // Setup mark image
    isRadio = data.type == .radio
    radioWidthContraint.priority = isRadio ? UILayoutPriorityDefaultHigh : UILayoutPriorityDefaultLow
    checkWidthContraint.priority = isRadio ? UILayoutPriorityDefaultLow : UILayoutPriorityDefaultHigh
  }

  // MARK: - Private

  private func image(selected: Bool, isRadio: Bool) -> UIImage {
    let radioImage = selected ? "img_radio_selected" : "img_radio_normal"
    let checkImage = selected ? "img_check_selected" : "img_check_normal"
    let imageName = isRadio ? radioImage : checkImage
    return UIImage(named: imageName)!
  }

}
