//
//  PermissionsManager.swift
//  CHMeetupApp
//
//  Created by Michael Galperin on 28.02.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit
import Photos
import AVKit
import EventKit
import UserNotifications

enum PermissionType: String {
  case notifications, calendar, reminders, camera, photosLibrary
}

/**
 Allows to check and request different permissions
 
 * Easily check
 
 `if PermissionsManager.isAllowed(type: .camera) { ... }`
 
 * Request needed permission
 
 `PermissionsManager.requestAccess(forType: .camera) { granted in }`
 
 * If permission is not granted but it is required for correct workflow, 
 suggest user to change his decision and open Settings
 
 `PermissionsManager.openSettings()`
 * You can also get default-styled `UIAlertController` for presenting while requesting rejected permission
 
 `let alert = PermissionsManager.alertForSettingsWith(type: .camera)`
 
 * It can be enough to use `UIViewController` extensioned function **requireAccess** 
 cause it contains final value of permission availability
 
 `controller.requireAccess(to: .camera) { granted in }`
 */

final class PermissionsManager {

  private enum PermissionConstants {
    static let askPhrases = [
      PermissionType.calendar: "к календарю".localized,
      .camera: "к камере".localized,
      .notifications: "к отправке уведомлений".localized,
      .photosLibrary: "к библиотеке фотографий".localized,
      .reminders: "к напоминаниям".localized
    ]

    static let askForAccess = "Пожалуйста, предоставьте приложению доступ".localized
    static let accessError = "Ошибка доступа".localized
    static let cancel = "Отмена".localized
    static let settings = "Настройки".localized
  }

  /** 
   Checks if user has granted access to `PermissionType`

  - parameter type: Type of permission to check. Check out `PermissionType` for possible values
  - returns: `Bool` describing if access is granted
  */
  static func isAllowed(type: PermissionType) -> Bool {
    switch type {
      case .photosLibrary:
        return PHPhotoLibrary.authorizationStatus() == .authorized
      case .camera:
        return AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == .authorized
      case .reminders:
        return EKEventStore.authorizationStatus(for: .reminder) == .authorized
      case .calendar:
        return EKEventStore.authorizationStatus(for: .event) == .authorized
      case .notifications:
        return UIApplication.shared.currentUserNotificationSettings?.types.contains(.alert) ?? false
    }
  }

  /** 
   Requests access to selected permission type.

  - parameter forType: `PermissionType` to request access for
  - parameter completion: Callback with `Bool` value describing if acess is granted by user
   */
  static func requestAccess(forType: PermissionType, completion: @escaping (Bool) -> Void) {
    if isAllowed(type: forType) {
      completion(true)
      return
    }

    switch forType {
      case .calendar:
        EKEventStore().requestAccess(to: .event) { result, _ in
          completion(result)
        }
      case .camera:
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { result in
          completion(result)
        }
      case .notifications:
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge]) { result, _ in
          completion(result)
       }
      case .photosLibrary:
        PHPhotoLibrary.requestAuthorization { status in
          completion(status == .authorized)
        }
      case .reminders:
        EKEventStore().requestAccess(to: .reminder) { result, _ in
          completion(result)
        }
    }
  }

  /**
   Default alert for requesting rejected permission from user
   
   - parameter type: `PermissionType` to request access for
   - returns: Ready to present instance of `UIAlertController`
  */
  static func alertForSettingsWith(type: PermissionType) -> UIAlertController {
    let phrase = PermissionConstants.askPhrases[type]
    assert(phrase != nil, "[PermissionsManager] Unknown PermissionType passed")

    let messageFull = "\(PermissionConstants.askForAccess) \(phrase!)"
    let alert = UIAlertController(title: PermissionConstants.accessError, message: messageFull, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: PermissionConstants.cancel, style: .default, handler: nil))
    alert.addAction(UIAlertAction(title: PermissionConstants.settings, style: .default) { _ in
      self.openSettings()
    })
    return alert
  }

  /**
    Allows to easily open Settings app for editing granted permissions.

    Make sure to **inform user** before opening Settings, also don't open it without user's confirmation
  */
  static func openSettings() {
    guard let url = URL(string: UIApplicationOpenSettingsURLString),
          UIApplication.shared.canOpenURL(url) else {
      return
    }
    UIApplication.shared.open(url, options: [:])
  }

}
