//
//  Router.swift
//  CHMeetupApp
//
//  Created by Igor Voynov on 19.04.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit
import ObjectiveC

private var associationRouterKey = "viewController_router"

typealias CompletionBlock = () -> Void

struct WeakContainer<T: AnyObject> {
  weak var value: T?
  init(value: T?) {
    self.value = value
  }
}

protocol Destination {
  var route: Route { get }
}

struct Route: Equatable {
  enum Back {
    case hide, returnToPoint
  }

  enum Next {
    case show, insert, createPoint
  }

  var to: UIViewController
  var direction: Next

  public static func == (lhs: Route, rhs: Route) -> Bool {
    return lhs.to == rhs.to && lhs.direction == lhs.direction
  }
}

final class Router {
  private(set) weak var parent: Router?
  private(set) weak var child: Router?

  private var viewControllers: [WeakContainer<UIViewController>] = []

  private var lastViewController: UIViewController {
    viewControllers = viewControllers.filter({ $0.value != nil })

    if let last = viewControllers.last?.value {
      return last
    } else {
      assertionFailure("Not last view controller in current router")
      return (UIApplication.shared.keyWindow?.rootViewController)!
    }
  }

  init(rootViewController: UIViewController, parent: Router? = nil) {
    viewControllers.append(WeakContainer(value: rootViewController))
    self.parent = parent
    parent?.child = self
  }

  func leave(to direction: Route.Back, completionHandler: CompletionBlock? = nil) {
    switch direction {
    case .hide:
      lastViewController.navigationController?.popToViewController(animated: true, completionHandler: completionHandler)
      viewControllers.removeLast()
    case .returnToPoint:
      if let preveousLastViewController = parent?.lastViewController {
        lastViewController.navigationController?.popToViewController(preveousLastViewController,
                                                                     animated: true,
                                                                     completionHandler: completionHandler)
      } else {
        assertionFailure("No preveous router")
      }
    }
  }

  func follow(to destination: Destination, completionHandler: CompletionBlock? = nil) {
    let route = destination.route
    var futureRouter = self
    switch route.direction {
    case .show:
      lastViewController.navigationController?.pushViewController(route.to, animated: true,
                                                                  completionHandler: completionHandler)
      viewControllers.append(WeakContainer(value: route.to))
    case .insert:
      if let index = lastViewController.navigationController?.viewControllers.index(of: lastViewController) {
        lastViewController.navigationController?.viewControllers.insert(route.to, at: index + 1)
        viewControllers.append(WeakContainer(value: route.to))
      } else {
        assertionFailure("No navigation controller hierarhy")
      }
    case .createPoint:
      let router = Router(rootViewController: route.to, parent: self)
      lastViewController.navigationController?.pushViewController(route.to, animated: true,
                                                                  completionHandler: completionHandler)
      futureRouter = router
    }
    route.to.router = futureRouter
  }
}

extension UINavigationController {
  func pushViewController(_ destination: UIViewController, animated: Bool, completionHandler: CompletionBlock?) {
    completeTransaction(completionHandler: completionHandler) {
      pushViewController(destination, animated: animated)
    }
  }

  func popToViewController(_ destination: UIViewController? = nil, animated: Bool,
                           completionHandler: CompletionBlock?) {
    completeTransaction(completionHandler: completionHandler) {
      if let destination = destination {
        popToViewController(destination, animated: animated)
      } else {
        popViewController(animated: animated)
      }
    }
  }

  private func completeTransaction(completionHandler: CompletionBlock?, block: () -> Void) {
    CATransaction.begin()
    block()
    CATransaction.setCompletionBlock(completionHandler)
    CATransaction.commit()
  }
}

extension UIViewController {
  var router: Router {
    get {
      if let router = objc_getAssociatedObject(self, &associationRouterKey) as? Router {
        return router
      } else {
        assertionFailure("You MUST setup Router inside")
        self.router = Router(rootViewController: self)
        return self.router
      }
    }
    set {
      objc_setAssociatedObject(self, &associationRouterKey, newValue, .OBJC_ASSOCIATION_RETAIN)
    }
  }
}
