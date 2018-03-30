//
//  ChooseProfilePhotoButton.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 29/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class ChooseProfilePhotoButton: UIButton {

  @IBOutlet var photoImageView: UIImageView!
  @IBOutlet private var addImageView: UIImageView!

  var borderColor: UIColor!
  private var borderTappedColor: UIColor {
    return borderColor.tapButtonChangeColor
  }
  private var borderWidth: CGFloat {
    return photoImageView.bounds.height * Constants.SystemSizes.imageViewBorderWidthPercentage
  }

  override func awakeAfter(using aDecoder: NSCoder) -> Any? {
    return self.loadFromNibIfEmbeddedInDifferentNib()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    (isHighlighted || isSelected) ? buttonTappedState() : buttonDefaultState()
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    borderColor = .white
  }

  private func buttonTappedState() {
    photoImageView.roundWithBorder(borderWidth, color: borderTappedColor)
    addImageView.roundWithBorder(borderWidth, color: borderTappedColor)
    photoImageView.backgroundColor = borderTappedColor
    addImageView.backgroundColor = borderTappedColor
  }

  private func buttonDefaultState() {
    photoImageView.roundWithBorder(borderWidth, color: borderColor)
    addImageView.roundWithBorder(borderWidth, color: borderColor)
    photoImageView.backgroundColor = .clear
    addImageView.backgroundColor = borderColor
  }

}
