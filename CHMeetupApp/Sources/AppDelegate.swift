//
//  AppDelegate.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 20/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit
import UserNotifications
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ActiveWindowManager {

  var pushHandler = PushHandler()
  var universalRouter: UniversalRouter!
  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    Fabric.with([Crashlytics.self])
    RealmController.shared.setup()
    AppearanceController.setupAppearance()
    // Seems that it's the most optimal way to swizzle, without adding Obj-c code into project
    SwizzlingController.swizzleMethods()

    universalRouter = UniversalRouter(with: window)

    application.registerForRemoteNotifications()

    return true
  }

  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
    NotificationCenter.default.post(name: .CloseSafariViewControllerNotification, object: url)
    return true
  }
}

// MARK: - Push notifications

extension AppDelegate {
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    PushNotificationsController.registerNotification(token: deviceToken)
  }

  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    // Print the error to console (you should alert the user that registration failed)
    print("APNs registration failed: \(error)")
  }

  func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
    pushHandler.handle(data: data, via: universalRouter)
  }
}
