//
//  CreatorsViewController.swift
//  CHMeetupApp
//
//  Created by Sam Mejlumyan on 16/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class CreatorsViewController: UIViewController, DisplayCollectionWithTableViewDelegate {
  @IBOutlet var tableView: UITableView! {
    didSet {
      let configuration = TableViewConfiguration(
        bottomInset: 8,
        bottomIndicatorInset: 0,
        estimatedRowHeight: 100)
      tableView.configure(with: .custom(configuration))
      tableView.registerHeaderNib(for: DefaultTableHeaderView.self)
    }
  }

  fileprivate var displayCollection: CreatorsViewDisplayCollection!

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = "Создатели".localized
    displayCollection = CreatorsViewDisplayCollection()
    tableView.registerNibs(from: displayCollection)
    displayCollection.delegate = self
    fetchCreators()
  }
}

// MARK: - UITableViewDataSource
extension CreatorsViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return displayCollection.headerHeight(for: section)
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView() as DefaultTableHeaderView
    header.headerLabel.text = displayCollection.headerTitle(for: section)
    return header
  }

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

// MARK: - UITableViewDelegate
extension CreatorsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    displayCollection.didSelect(indexPath: indexPath)
  }
}

fileprivate extension CreatorsViewController {
  func fetchCreators() {
    displayCollection.creators.isLoading = true
    CreatorsController.fetchElements(request: CreatorPlainObject.Requests.list, completion: { [weak self] in
      self?.displayCollection.creators.isLoading = false
      self?.tableView.reloadData()
    })
  }
}
