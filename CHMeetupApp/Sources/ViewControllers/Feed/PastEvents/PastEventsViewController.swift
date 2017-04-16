//
//  PastEventsViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 22/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class PastEventsViewController: UIViewController {
  @IBOutlet fileprivate var tableView: UITableView! {
    didSet {
      tableView.configure(with: .defaultConfiguration)
    }
  }

  fileprivate var displayCollection: PastEventsDisplayCollection!

  override func viewDidLoad() {
    super.viewDidLoad()

    displayCollection = PastEventsDisplayCollection()
    displayCollection.delegate = self
    tableView.registerNibs(from: displayCollection)

    title = "Past".localized
    fetchEvents()
  }

  override func customTabBarItemContentView() -> CustomTabBarItemView {
    return TabBarItemView.create(with: .past)
  }

}

extension PastEventsViewController: UITableViewDataSource, UITableViewDelegate {

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

fileprivate extension PastEventsViewController {
  func fetchEvents() {
    EventFetching.fetchElements(request: EventPlainObject.Requests.pastList, completion: { [weak self] in
      self?.tableView.reloadData()
    })
  }
}
