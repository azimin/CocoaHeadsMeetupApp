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
        viewControllers = [ViewControllersFactory.profileViewController]
      }
    } else {
      if !viewControllers.contains(where: {$0 is AuthViewController}) {
        viewControllers = [ViewControllersFactory.authViewController]
      }
    }
  }

  override func customTabBarItemContentView() -> CustomTabBarItemView {
    return TabBarItemView.create(with: .profile)
  }
}
