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
  var nextTransition: Route? { get set }
  func transition(from: UIViewController, route: Route, completionHandler: CompletionBlock?)
}

extension Router {
  func transition(from: UIViewController, route: Route, completionHandler: CompletionBlock? = nil) {
    transition(from: from, route: route, completionHandler: completionHandler)
  }
}

class RouterDefault: Router {
  var nextTransition: Route? { didSet { print("didSet value:", nextTransition ?? "nil") }}
  func transition(from: UIViewController, route: Route, completionHandler: CompletionBlock?) {
    from.transition(rule: route.rule, completionHandler: completionHandler)
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
      if let position = position, let navigationController = navigationController {
        if let index = navigationController.viewControllers.index(where: {$0 == rule.to}) {
          navigationController.viewControllers.remove(at: index)
        }
        navigationController.viewControllers.insert(rule.to, at: navigationController.viewControllers.count + position)
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

  var router: Router {
    get {
      return (objc_getAssociatedObject(self, &associationKey) as? Router) ?? RouterDefault()
    }
    set {
      objc_setAssociatedObject(self, &associationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
    }
  }
}
