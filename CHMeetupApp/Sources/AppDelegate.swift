//
//  AppDelegate.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 20/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ActiveWindowManager {

  var window: UIWindow?
  var pushNotificationsController: GetPushNotificationController!

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    RealmController.shared.setup()
    AppearanceController.setupAppearance()
    pushNotificationsController = GetPushNotificationController(with: self)
    // Seems that is most optimal way now to swizzle, without adding Obj-c code into project
    SwizzlingController.swizzleMethods()

    if PermissionsManager.isAllowed(type: .notifications) {
      PushNotificationController.configureNotification()
    }

    setupRouter(viewController: window?.rootViewController)

    return true
  }

  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
    NotificationCenter.default.post(name: .CloseSafariViewControllerNotification, object: url)
    return true
  }

  func setupRouter(viewController: UIViewController?) {
    if let tabBarViewController = viewController as? UITabBarController {
      for viewController in tabBarViewController.viewControllers ?? [] {
        setupRouter(viewController: viewController)
      }
    } else if let navigationController = viewController as? UINavigationController,
      let viewController = navigationController.viewControllers.first {
      setupRouter(viewController: viewController)
    } else if let viewController = viewController {
      viewController.router = Router(rootViewController: viewController)
    } else {
      assertionFailure("No such view cotnroller")
    }
  }
}
