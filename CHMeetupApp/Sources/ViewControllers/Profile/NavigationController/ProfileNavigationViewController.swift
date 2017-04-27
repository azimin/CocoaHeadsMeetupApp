//
//  ProfileNavigationViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 23/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

protocol ProfileNavigationControllerType {
  func updateRootViewController()
}

class ProfileNavigationViewController: NavigationViewController, ProfileNavigationControllerType {

  override func viewDidLoad() {
    super.viewDidLoad()

    updateRootViewController()
    // Do any additional setup after loading the view.
  }

  func updateRootViewController() {
    if LoginProcessController.isLogin {
      if !viewControllers.contains(where: {$0 is ProfileViewController}) {
        let profileViewController = ViewControllersFactory.profileViewController
        profileViewController.router = Router(rootViewController: profileViewController)
        viewControllers = [profileViewController]
      }
    } else {
      if !viewControllers.contains(where: {$0 is AuthViewController}) {
        let authViewController = ViewControllersFactory.authViewController
        authViewController.router = Router(rootViewController: authViewController)
        viewControllers = [authViewController]
      }
    }
  }

  override func customTabBarItemContentView() -> CustomTabBarItemView {
    return TabBarItemView.create(with: .profile)
  }
}
