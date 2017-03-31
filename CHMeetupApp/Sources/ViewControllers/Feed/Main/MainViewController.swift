//
//  MainViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 22/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.configure(with: .defaultConfiguration)
    }
  }

  fileprivate var displayCollection: MainViewDisplayCollection!

  override func viewDidLoad() {
    super.viewDidLoad()

    displayCollection = MainViewDisplayCollection()
    tableView.registerNibs(from: displayCollection)

    title = "Main".localized

    view.backgroundColor = UIColor(.lightGray)
    // Do any additional setup after loading the view.
  }

  @IBAction func showEventAction(_ sender: UIButton) {
    navigationController?.pushViewController(ViewControllersFactory.eventPreviewViewController, animated: true)
  }

  override func customTabBarItemContentView() -> CustomTabBarItemView {
    return TabBarItemView.create(with: .main)
  }
}

extension MainViewController: UITableViewDataSource {
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
}

extension MainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    navigationController?.pushViewController(ViewControllersFactory.eventPreviewViewController, animated: true)
  }
}
