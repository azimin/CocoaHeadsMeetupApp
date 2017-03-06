//
//  ActionButton.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 04/03/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class ActionButton: UIButton {

  private var nessesaryBackgroundColor: UIColor?
  private var isSetup = false
  private var notChange = false

  override var backgroundColor: UIColor? {
    didSet {
      if oldValue == backgroundColor || notChange {
        notChange = false
        return
      }

      if !isSetup {
        nessesaryBackgroundColor = backgroundColor
        notChange = true
        backgroundColor = oldValue
      }

      updateAppearance()
    }
  }

  private func updateAppearance() {
    isSetup = true
    if (isSelected || isHighlighted) && isEnabled {
      backgroundColor = nessesaryBackgroundColor?.tapButtonChangeColor
    } else {
      backgroundColor = nessesaryBackgroundColor
    }

    if !isEnabled {
      self.alpha = 0.8
    } else {
      self.alpha = 1
    }

    isSetup = false
  }

  override var isHighlighted: Bool {
    didSet {
      if oldValue != isHighlighted {
        updateAppearance()
      }
    }
  }

  override var isEnabled: Bool {
    didSet {
      if oldValue != isEnabled {
        updateAppearance()
      }
    }
  }

  override var isSelected: Bool {
    didSet {
      if oldValue != isSelected {
        updateAppearance()
      }
    }
  }

}
