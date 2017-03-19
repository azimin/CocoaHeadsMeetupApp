//
//  BottomButton.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 19/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class BottomButton: ActionButton {
  private struct Constants {
    static var height: CGFloat = 50
    static var backgroundColor: UIColor = UIColor(.pink)
    static var titleFont: UIFont = UIFont.appFont(.gothamProMedium(size: 15))
    static var titleColor: UIColor = UIColor(.white)
  }

  var bottomInsetsConstant: CGFloat = 0 {
    didSet {
      // Becuase it's bottom constaint, to go up it should be reversed
      bottomConstraint.constant = -bottomInsetsConstant
    }
  }

  private var bottomConstraint: NSLayoutConstraint!

  init(addingOnView view: UIView, title: String) {
    super.init(frame: .zero)

    view.addSubview(self)
    anchor(leading: view.leftAnchor,
           trailing: view.rightAnchor,
           heightConstant: Constants.height)

    bottomConstraint = bottomAnchor.constraint(equalTo: view.bottomAnchor)
    bottomConstraint.isActive = true

    setTitle(title, for: .normal)

    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    backgroundColor = Constants.backgroundColor
    titleLabel?.font = Constants.titleFont
    setTitleColor(Constants.titleColor, for: .normal)
  }
}
