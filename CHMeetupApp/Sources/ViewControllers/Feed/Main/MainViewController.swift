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
    displayCollection.configureActionCellsSection(on: self, with: tableView)
    displayCollection.delegate = self

    tableView.registerNibs(from: displayCollection)

    title = "Main".localized

    fetchEvents()

    // Do any additional setup after loading the view.
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
    tableView.deselectRow(at: indexPath, animated: true)
    displayCollection.didSelect(indexPath: indexPath)
  }
}

extension MainViewController: MainViewDisplayCollectionDelegate {
  func shouldPresent(viewController: UIViewController) {
    navigationController?.pushViewController(viewController, animated: true)
  }
}

// FIXME: - Move into personal structure, 
// When https://trello.com/c/XQgNIbD5/194-fetchevents-pasteventsviewcontroller would be done
fileprivate extension MainViewController {
  func fetchEvents() {
    Server.standard.request(EventPlainObject.Requests.list, completion: { [weak self] list, error in
      guard let list = list,
        error == nil else { return }

      EventPlainObjectTranslation.translate(of: list, to: nil)
      self?.tableView.reloadData()
    })
  }
}
