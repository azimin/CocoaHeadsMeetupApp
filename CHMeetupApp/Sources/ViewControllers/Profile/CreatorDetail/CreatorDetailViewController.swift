//
//  CreatorDetailViewController.swift
//  CHMeetupApp
//
//  Created by Andrey Konstantinov on 01/07/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

final class CreatorDetailViewController: UIViewController {

  var creatorId: Int!

  @IBOutlet private var tableView: UITableView! {
    didSet {
      tableView.configure(with: .defaultConfiguration)
    }
  }

  var displayCollection: CreatorDetailDisplayCollection!

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Создатель".localized
    view.backgroundColor = UIColor(.lightGray)

    displayCollection = CreatorDetailDisplayCollection()
    displayCollection.delegate = self
    tableView.registerNibs(from: displayCollection)

    let dataModel = DataModelCollection(type: CreatorEntity.self)
    displayCollection.creator = dataModel.first(where: { $0.id == creatorId })
  }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CreatorDetailViewController: UITableViewDelegate, UITableViewDataSource {

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
