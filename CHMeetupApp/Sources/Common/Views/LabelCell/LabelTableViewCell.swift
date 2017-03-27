//
//  LabelTableViewCell.swift
//  CHMeetupApp
//
//  Created by Sergey Zapuhlyak on 22/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

final class LabelTableViewCell: PlateTableViewCell {

  @IBOutlet private var titleLabel: UILabel! {
    didSet {
      titleLabel.numberOfLines = 0
      titleLabel.font = UIFont.appFont(.gothamProMedium(size: 15))
      titleLabel.textColor = UIColor(.gray)
      titleLabel.text = " "
    }
  }

  @IBOutlet private var infoLabel: UILabel! {
    didSet {
      infoLabel.numberOfLines = 0
      infoLabel.font = UIFont.appFont(.gothamPro(size: 15))
      infoLabel.textColor = UIColor(.black)
      infoLabel.text = " "
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
    titleLabel.textColor = shouldSelect ? UIColor(.black) : UIColor(.gray)
  }

  func setup(title: String, info: String) {
    titleLabel.text = title
    infoLabel.text = info
  }

}
