//
//  ShadowView.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 11/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

// Class with our configuration
class ShadowView: UIView {

  private var shadowViewAppearanceValue: ShadowViewAppearance? {
    didSet {
      updateAppearance()
    }
  }

  // For UIAppearance proxy
  @objc dynamic var shadowViewAppearance: ShadowViewAppearance? {
    set {
      shadowViewAppearanceValue = newValue
    }
    get {
      return shadowViewAppearanceValue
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    updateAppearance()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    updateAppearance()
  }

  private func updateAppearance() {
    layer.shadowOpacity = shadowViewAppearanceValue?.shadowOpacity ?? 0.1
    layer.shadowColor = shadowViewAppearanceValue?.shadowColor.cgColor ?? UIColor(.black).cgColor
    layer.shadowRadius = shadowViewAppearanceValue?.shadowRadius ?? 2
    layer.shadowOffset = CGSize.zero
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
  }
}
