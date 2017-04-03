//
//  AlertGlobal.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 03/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class AlertGlobal {
  static func showAlert(on viewController: UIViewController,
                        title: String? = nil, message: String? = nil,
                        actions: [UIAlertAction]? = nil, style: UIAlertControllerStyle = .alert) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: style)
    if let actions = actions {
      actions.forEach({ action in alert.addAction(action) })
    } else {
      alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))
    }
    viewController.present(alert, animated: true, completion: nil)
  }
}
