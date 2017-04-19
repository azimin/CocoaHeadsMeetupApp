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
  var nextTransition: Route? { get set }
  func transition(from: UIViewController, route: Route)
}

class RouterDefault: Router {
  var nextTransition: Route? { didSet { print("didSet value:", nextTransition ?? "nil") }}
  func transition(from: UIViewController, route: Route) {
    from.transition(rule: route.rule)
  }
}

extension UIViewController {
  func transition(rule: Route.RouteRule) {
    switch rule.direction {
    case .push:
      navigationController?.pushViewController(rule.to, animated: true)
    case .pop(let position):
      if let position = position, let navigationController = navigationController {
        if let index = navigationController.viewControllers.index(where: {$0 == rule.to}) {
          navigationController.viewControllers.remove(at: index)
        }
        navigationController.viewControllers.insert(rule.to, at: navigationController.viewControllers.count + position)
      }
      navigationController?.popToViewController(rule.to, animated: true)
    case .present:
      present(rule.to, animated: true, completion: nil)
    case .dismiss:
      dismiss(animated: true, completion: nil)
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
