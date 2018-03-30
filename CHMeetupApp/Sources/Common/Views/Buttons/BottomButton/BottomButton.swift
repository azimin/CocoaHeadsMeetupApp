//
//  BottomButton.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 19/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class BottomButton: ActionButton {

  enum BottonButtonStyle {
    case colorful
    case canceling

    var backgroundColor: UIColor {
      switch self {
      case .colorful:
        return UIColor(.pink)
      case .canceling:
        return UIColor(.gray)
      }
    }

    var titleColor: UIColor {
      switch self {
      case .colorful:
        return UIColor(.white)
      case .canceling:
        return UIColor(.white)
      }
    }

  }

  var style: BottonButtonStyle = .colorful {
    didSet {
      setup()
    }
  }

  private struct Constants {
    static var height: CGFloat = 50
    static var titleFont: UIFont = UIFont.appFont(.avenirNextDemiBold(size: 16))
    static var cornerRadius = Constants.height / 2.0
    static var leadingConstant: CGFloat = 8.0
    static var trailingConstant: CGFloat = -8.0
  }

  static var constantHeight: CGFloat {
    return Constants.height
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
    anchor(leading: view.leadingAnchor,
           trailing: view.trailingAnchor,
           leadingConstant: Constants.leadingConstant,
           trailingConstant: Constants.trailingConstant,
           heightConstant: Constants.height)

    self.layer.cornerRadius = Constants.cornerRadius

    if #available(iOS 11.0, *) {
      bottomConstraint = bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    } else {
      bottomConstraint = bottomAnchor.constraint(equalTo: view.bottomAnchor)
    }
    bottomConstraint.isActive = true

    setTitle(title, for: .normal)

    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    backgroundColor = style.backgroundColor
    titleLabel?.font = Constants.titleFont
    setTitleColor(style.titleColor, for: .normal)
  }
}
