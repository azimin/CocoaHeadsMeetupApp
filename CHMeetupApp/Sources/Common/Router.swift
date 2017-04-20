//
//  Router.swift
//  CHMeetupApp
//
//  Created by Igor Voynov on 19.04.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit
import ObjectiveC

private var associationKey = "viewController_router"

enum RouteDirection {
  case push, pop(position: Int?), present, dismiss
}

protocol Route {
  typealias RouteRule = (to: UIViewController, direction: RouteDirection)
  var rule: RouteRule { get }
}

protocol Router: class {
  typealias CompletionBlock = () -> Void

  var viewController: UIViewController? { get }
  init(_ vc: UIViewController?)

  var nextTransition: Route? { get set }
  func transition(route: Route, completionHandler: CompletionBlock?)
}

extension Router {
  func transition(route: Route, completionHandler: CompletionBlock? = nil) {
    transition(route: route, completionHandler: completionHandler)
  }
}

class RouterDefault: Router {
  var viewController: UIViewController?
  required init(_ vc: UIViewController?) {
    viewController = vc
  }

  var nextTransition: Route? { didSet { print("didSet value:", nextTransition ?? "nil") }}
  func transition(route: Route, completionHandler: CompletionBlock?) {
    viewController?.transition(rule: route.rule, completionHandler: completionHandler)
  }
}

extension UIViewController {
  func transition(rule: Route.RouteRule, completionHandler: Router.CompletionBlock?) {
    switch rule.direction {
    case .push:
      CATransaction.begin()
      navigationController?.pushViewController(rule.to, animated: true)
      CATransaction.setCompletionBlock(completionHandler)
      CATransaction.commit()
    case .pop(let position):
      if let position = position,
        let index = navigationController?.viewControllers.index(where: {$0 == rule.to}),
        let count = navigationController?.viewControllers.count {
        navigationController?.viewControllers.remove(at: index)
        navigationController?.viewControllers.insert(rule.to, at: count + position)
      }
      CATransaction.begin()
      navigationController?.popToViewController(rule.to, animated: true)
      CATransaction.setCompletionBlock(completionHandler)
      CATransaction.commit()
    case .present:
      present(rule.to, animated: true, completion: completionHandler)
    case .dismiss:
      dismiss(animated: true, completion: completionHandler)
    }
  }

  static var rootViewController: UIViewController? {
    return UIApplication.shared.delegate?.window??.rootViewController
  }

  // swiftlint:disable:next line_length
  func topViewController(from viewController: UIViewController? = UIViewController.rootViewController) -> UIViewController? {
    if let tabBarViewController = viewController as? UITabBarController {
      return topViewController(from: tabBarViewController.selectedViewController)
    } else if let navigationController = viewController as? UINavigationController {
      return topViewController(from: navigationController.visibleViewController)
    } else if let presentedViewController = viewController?.presentedViewController {
      return topViewController(from: presentedViewController)
    } else {
      return viewController
    }
  }

  var router: Router {
    get {
      return (objc_getAssociatedObject(self, &associationKey) as? Router) ?? RouterDefault(topViewController())
    }
    set {
      objc_setAssociatedObject(self, &associationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
    }
  }
}
