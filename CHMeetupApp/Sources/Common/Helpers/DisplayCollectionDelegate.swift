//
//  DisplayCollectionDelegate.swift
//  CHMeetupApp
//
//  Created by Sam Mejlumyan on 11/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

protocol DisplayCollectionDelegate: class {
  func updateUI()
  func present(viewController: UIViewController)
  func follow(destination: Destination)
}

extension UIViewController: DisplayCollectionDelegate {
  func present(viewController: UIViewController) {
    present(viewController, animated: true, completion: nil)
  }

  func follow(destination: Destination) {
    router.follow(to: destination, completionHandler: nil)
  }

  func updateUI() {
    if let tableView = self.value(forKey: "tableView") as? UITableView {
      tableView.reloadData()
    }
  }
}
