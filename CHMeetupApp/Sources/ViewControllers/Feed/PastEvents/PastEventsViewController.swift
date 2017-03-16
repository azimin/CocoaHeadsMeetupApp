//
//  PastEventsViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 22/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class PastEventsViewController: UIViewController, PastEventsDisplayCollectionDelegate {
  @IBOutlet fileprivate var tableView: UITableView! {
    didSet {
      tableView.registerNib(for: EventPreviewTableViewCell.self)
      tableView.estimatedRowHeight = 100
      tableView.rowHeight = UITableViewAutomaticDimension
      tableView.backgroundColor = UIColor.clear
      tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
  }
  fileprivate var dataCollection: PastEventsDisplayCollection!

  override func viewDidLoad() {
    super.viewDidLoad()

    dataCollection = PastEventsDisplayCollection()
    dataCollection.delegate = self

    view.backgroundColor = UIColor(.lightGray)

    title = "Past".localized

    fetchPastEvents()
  }

  override func customTabBarItemContentView() -> CustomTabBarItemView {
    return TabBarItemView.create(with: .past)
  }

  func shouldPresent(viewController: UIViewController) {
    navigationController?.pushViewController(viewController, animated: true)
  }

  func fetchPastEvents() {
    Server.standard.request(EventPlainObject.Requests.list, completion: { list, error in
      guard let _ = list,
      error == nil else { return }
      // TODO: Create realm objects from plainobjects array
      // let entities = list.flatMap(EventEntity.init)
    })
  }
}

extension PastEventsViewController: UITableViewDataSource, UITableViewDelegate {

  func numberOfSections(in tableView: UITableView) -> Int {
    return dataCollection.numberOfSections
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataCollection.numberOfRows(in: section)
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = dataCollection.model(for: indexPath)
    let cell = tableView.dequeueReusableCell(for: indexPath, with: model)
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    dataCollection.didSelect(indexPath: indexPath)
  }
}
