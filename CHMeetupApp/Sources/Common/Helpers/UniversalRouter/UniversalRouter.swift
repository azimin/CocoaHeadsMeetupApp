//
//  UniversalRouter.swift
//  CHMeetupApp
//
//  Created by Sam Mejlumyan on 17/07/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

final class UniversalRouter {
  private var mainWindow: UIWindow?
  private var tabBarController: TabBarViewController!

  init(with window: UIWindow?) {
    mainWindow = window

    guard let rootController = mainWindow?.rootViewController as? TabBarViewController else {
      fatalError("RootViewController should be TabBarViewController")
    }
    tabBarController = rootController
  }


  // Tab bar section 
  // By default, enum sets the first case 0
  // So anonses is 0, pastEvents 1, profile 2
  enum TabBarSection {
    case anonses
    case pastEvents
    case profile
  }

  func activate(section: TabBarSection) {
    self.tabBarController.selectedIndex = section.hashValue
  }

  func updateAnonseStatus(`for` eventId: Int, status: String) {
    let status = EventEntity.EventRegistrationStatus(rawValue: status)
    let anonses = viewController(for: .anonses) as? MainViewController
    anonses?.updateStateFor(event: eventId, status: status ?? .unknown)
  }

  private func viewController(for section: TabBarSection) -> UIViewController? {
    // swiftlint:disable:next line_length
    let navigationVC = self.tabBarController.viewControllers?[section.hashValue] as? UINavigationController
    return navigationVC?.viewControllers.first
  }
}
