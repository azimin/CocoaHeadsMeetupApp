//
//  ActionButtonTableViewCell.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 04/03/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class ActionButtonTableViewCell: UITableViewCell {

  @IBAction func buttonDidTap(sender: UIButton) {
    actionByTap?(self)
  }

  @IBOutlet var actionButton: UIButton!

  private var actionByTap: ((ActionButtonTableViewCell) -> Void)?

  func addAction(title: String, handler: @escaping(ActionButtonTableViewCell) -> Void ) {
    actionButton.setTitle(title, for: .normal)
    actionByTap = handler
  }
}

extension ActionButtonTableViewCell: ReusableCell {

  static var identifier: String {
    return String(describing: self)
  }

  static var nib: UINib? {
    return UINib(nibName: String(describing: self), bundle: nil)
  }
}

