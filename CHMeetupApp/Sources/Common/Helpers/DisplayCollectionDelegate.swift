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
  func push(viewController: UIViewController)
}

extension UIViewController: DisplayCollectionDelegate {
  func present(viewController: UIViewController) {
    present(viewController, animated: true, completion: nil)
  }

  func push(viewController: UIViewController) {
    navigationController?.pushViewController(viewController, animated: true)
  }

  func updateUI() {
    if let tableView = self.value(forKey: "tableView") as? UITableView {
      tableView.reloadData()
    }
  }
}
