//
//  CreatorsViewController.swift
//  CHMeetupApp
//
//  Created by Sam Mejlumyan on 16/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit
import SVProgressHUD

class CreatorsViewController: UIViewController {
  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.configure(with: .defaultConfiguration)
    }
  }

  fileprivate var displayCollection: CreatorsViewDisplayCollection!

  override func viewDidLoad() {
    super.viewDidLoad()
    SVProgressHUD.show()
    navigationItem.title = "Создатели".localized
    displayCollection = CreatorsViewDisplayCollection(with: [])
    tableView.registerNibs(from: displayCollection)

    CreatorsController.loadList { [weak self] users, _ in
      SVProgressHUD.dismiss()
      guard let users = users else { return }
      self?.displayCollection = CreatorsViewDisplayCollection(with: users)
      self?.tableView.reloadData()
    }
  }
}

// MARK: - TableViewDelegate
extension CreatorsViewController: TableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return displayCollection.numberOfSections
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return displayCollection.numberOfRows(in: section)
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = displayCollection.model(for: indexPath)
    let cell = tableView.dequeueReusableCell(for: indexPath, with: model)
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    displayCollection.didSelect(indexPath: indexPath)
  }
}
