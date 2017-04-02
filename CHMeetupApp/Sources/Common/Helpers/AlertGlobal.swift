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
                        title: String?, message: String?, actions: [UIAlertAction]?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    if let actions = actions {
      actions.forEach({ action in alert.addAction(action) })
    } else {
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
    viewController.present(alert, animated: true, completion: nil)
  }
}
