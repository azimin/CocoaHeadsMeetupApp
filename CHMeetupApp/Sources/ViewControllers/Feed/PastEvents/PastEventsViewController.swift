//
//  PastEventsViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 22/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

// TODO: Reverse when finish
class PastEventsViewController: UIViewController, ActionCellConfigurationDelegate {
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
    dataCollection.delegate = self
    dataCollection.checkPermission()
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

  func successPermission(on tableView: UITableView, cellAt indexPath: IndexPath, with result: Bool) {
    if result {
      DispatchQueue.main.async {
        self.dataCollection.actionPlainObjects.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
      }
    }
  }
}

extension PastEventsViewController: UITableViewDataSource, UITableViewDelegate {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataCollection.actionPlainObjects.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = dataCollection.modelForRemindersPermission(at: indexPath)
    let cell = tableView.dequeueReusableCell(for: indexPath, with: model)
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    dataCollection.requestAccess(on: self, with: tableView, cellAt: indexPath)
    tableView.deselectRow(at: indexPath, animated: true)
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
