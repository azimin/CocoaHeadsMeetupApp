//
//  UIViewController+HUD.swift
//  CHMeetupApp
//
//  Created by Maria Ionchenkova on 15/08/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation
import SVProgressHUD

extension UIViewController {
  func showProgressHUD() {
    DispatchQueue.main.async {
      SVProgressHUD.show()
      self.view.isUserInteractionEnabled = false
    }
  }

  func dismissProgressHUD() {
    DispatchQueue.main.async {
      SVProgressHUD.dismiss()
      self.view.isUserInteractionEnabled = true
    }
  }
}
