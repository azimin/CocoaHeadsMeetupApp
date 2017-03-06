//
//  UIViewController+RequireAccess.swift
//  CHMeetupApp
//
//  Created by Michael Galperin on 02.03.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

extension UIViewController {

  /// Helps to perform any action only if required permission is granted. 
  /// Displays an alert with invitation to the Settings app if first request was rejected by user
  ///
  /// - parameter type: Permission to be required
  /// - parameter completion: `Bool` value of permission availability
  func requireAccess(to type: PermissionType, completion: @escaping (Bool) -> Void) {
    if !PermissionsManager.isAllowed(type: type) {
      PermissionsManager.requestAccess(forType: type) { success in
        completion(success)
        if !success {
          let alert = PermissionsManager.alertForSettingsWith(type: type)
          DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
          }
        }
      }
    } else {
      completion(true)
    }
  }

}
