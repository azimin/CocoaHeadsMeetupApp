//
//  LoginProcessViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 23/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation

private let loginName = "UD.key.isLogin"

class LoginProcessViewController {

  // FIXME: - Move to realm
  static var isLogin: Bool {
    set {
      UserDefaults.standard.set(newValue, forKey: loginName)
    }
    get {
      return UserDefaults.standard.bool(forKey: loginName)
    }
  }
}

extension Notification.Name {
  static let CloseSafariViewControllerNotification: Notification.Name =
    Notification.Name(rawValue: "CloseSafariViewControllerNotification")
}
