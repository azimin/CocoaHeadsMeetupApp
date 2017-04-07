//
//  NavigationViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 22/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

  var shadowView: ShadowView!

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationBar.shadowImage = UIImage()
    navigationBar.setBackgroundImage(UIImage(), for: .default)

    navigationBar.barTintColor = UIColor(.white)
    navigationBar.isTranslucent = false
    navigationBar.tintColor = UIColor(.black)
    
    shadowView = ShadowView()
    view.insertSubview(shadowView, belowSubview: navigationBar)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    shadowView.frame = navigationBar.frame
  }

  override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    viewControllers.last?.makeBackButtonEmpty()
    super.pushViewController(viewController, animated: animated)
  }
}
