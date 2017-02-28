//
//  JoinButtonCell.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 28/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class JoinButtonCell: UITableViewCell {

  var navigationViewController = UINavigationController()

  @IBAction func jointToEventButton(_ sender: UIButton) {
    JoinButtonCell.goToRegistrationPreview(via: navigationViewController)
  }

  static var nib: UINib {
    return UINib(nibName: String(describing: self), bundle: nil)
  }

  static var identifier: String {
    return String(describing: self)
  }

}

extension JoinButtonCell {

  static func goToRegistrationPreview(via: UINavigationController) {
    let storyboard = UIStoryboard(name: "EventPreview", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "RegistrationPreviewViewController")
    via.pushViewController(viewController, animated: true)
  }
}
