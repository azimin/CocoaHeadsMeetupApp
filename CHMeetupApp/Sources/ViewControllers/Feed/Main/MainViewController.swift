//
//  MainViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 22/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, DisplayCollectionWithTableViewDelegate {

  var currentUserId: Int? = -1

  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.configure(with: .defaultConfiguration)
    }
  }

  fileprivate var displayCollection: MainViewDisplayCollection!

  override func viewDidLoad() {
    super.viewDidLoad()

    displayCollection = MainViewDisplayCollection()
    displayCollection.updateActionCellsSection(on: self, with: tableView)
    displayCollection.delegate = self
    tableView.registerNibs(from: displayCollection)

    title = "CocoaHeads Russia".localized
    // Do any additional setup after loading the view.
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tableView.reloadData()

    if currentUserId != UserPreferencesEntity.value.currentUser?.remoteId {
      fetchEvents()
      currentUserId = UserPreferencesEntity.value.currentUser?.remoteId
    }
  }

  override func customTabBarItemContentView() -> CustomTabBarItemView {
    return TabBarItemView.create(with: .main)
  }

  override func updateUI() {
    displayCollection.updateActionCellsSection(on: self, with: tableView)
    super.updateUI()
  }

  func updateStateFor(event: Int, status: EventEntity.EventRegistrationStatus) {
    let event = mainRealm.objects(EventEntity.self).first(where: { $0.id == event })
    realmWrite {
      event?.status = status
    }
    updateUI()
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

fileprivate extension MainViewController {
  func fetchEvents() {
    displayCollection.modelCollection.isLoading = true
    EventFetching.fetchElements(request: EventPlainObject.Requests.list, completion: { [weak self] in
      EventEntity.resetLoadingEntitiesStatus()
      self?.displayCollection.modelCollection.isLoading = false
      self?.tableView.reloadData()
    })
  }
}
