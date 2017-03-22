//
//  PastEventsViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 22/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

// TODO: Reverse when finish
class PastEventsViewController: UIViewController {
  @IBOutlet fileprivate var tableView: UITableView! {
    didSet {
      tableView.registerNib(for: ActionTableViewCell.self)
      tableView.estimatedRowHeight = 100
      tableView.rowHeight = UITableViewAutomaticDimension
      tableView.backgroundColor = UIColor.clear
      tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
  }
  fileprivate var dataCollection: ActionCellConfigurationController!

  override func viewDidLoad() {
    super.viewDidLoad()

    dataCollection = ActionCellConfigurationController()

    view.backgroundColor = UIColor(.lightGray)

    title = "Past".localized

    fetchEvents()
  }

  override func customTabBarItemContentView() -> CustomTabBarItemView {
    return TabBarItemView.create(with: .past)
  }

  func shouldPresent(viewController: UIViewController) {
    navigationController?.pushViewController(viewController, animated: true)
  }
}

extension PastEventsViewController: UITableViewDataSource, UITableViewDelegate {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = dataCollection.configureCellWithPermisson()
    let cell = tableView.dequeueReusableCell(for: indexPath, with: model)
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    dataCollection.action(on: self)
  }
}

fileprivate extension PastEventsViewController {

  func fetchEvents() {
    Server.standard.request(EventPlainObject.Requests.pastList, completion: { list, error in
      guard let list = list,
        error == nil else { return }

      EventPlainObjectTranslation.translate(of: list)
      self.tableView.reloadData()
    })
  }
}
