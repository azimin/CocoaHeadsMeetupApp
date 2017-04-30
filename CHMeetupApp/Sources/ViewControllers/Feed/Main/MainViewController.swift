//
//  MainViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 22/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, DisplayCollectionWithTableViewDelegate {

  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.configure(with: .defaultConfiguration)
    }
  }

  fileprivate var displayCollection: MainViewDisplayCollection!

  override func viewDidLoad() {
    super.viewDidLoad()

    displayCollection = MainViewDisplayCollection()
    displayCollection.configureActionCellsSection(on: self, with: tableView)
    displayCollection.delegate = self
    tableView.registerNibs(from: displayCollection)

    title = "CocoaHeads Russia".localized
    fetchEvents()

    // Do any additional setup after loading the view.
  }

  override func customTabBarItemContentView() -> CustomTabBarItemView {
    return TabBarItemView.create(with: .main)
  }
}

// MARK: - TableViewDelegate
extension MainViewController: TableViewDelegate {
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

fileprivate extension MainViewController {
  func fetchEvents() {
    displayCollection.modelCollection.isLoading = true
    EventFetching.fetchElements(request: EventPlainObject.Requests.list, completion: { [weak self] in
      self?.displayCollection.modelCollection.isLoading = false
      self?.tableView.reloadData()
    })
  }
}
