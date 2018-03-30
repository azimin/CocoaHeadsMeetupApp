//
//  LightButton.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 11/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class LightButton: UIButton {

  var borderColor = UIColor(.lightGray) {
    didSet {
      updateAppearance()
    }
  }

  var titleColor = UIColor(.gray) {
    didSet {
      updateAppearance()
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  private func setup() {
    updateAppearance()
  }

  private func updateAppearance() {
    layer.cornerRadius = 4
    layer.borderWidth = 1
    layer.borderColor = borderColor.cgColor
    setTitleColor(titleColor, for: .normal)
  }
}
