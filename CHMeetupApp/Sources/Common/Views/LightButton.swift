//
//  LightButton.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 11/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class LightButton: UIButton {

  override var tintColor: UIColor! {
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
    // FIXME: - Take light grey
    tintColor = UIColor(.grey)
  }

  private func updateAppearance() {
    layer.cornerRadius = 4
    layer.borderWidth = 1
    layer.borderColor = tintColor.cgColor
    setTitleColor(tintColor, for: .normal)
  }
}
