//
//  RegistrationConfirmViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 23/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class RegistrationConfirmViewController: UIViewController, UIViewControllerWithTableView {

  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.allowsMultipleSelection = true
      let configuration = TableViewConfiguration(
        bottomInset: 8 + BottomButton.constantHeight,
        bottomIndicatorInset: BottomButton.constantHeight,
        estimatedRowHeight: 44
      )
      tableView.configure(with: .custom(configuration))
    }
  }

  fileprivate var bottomButton: BottomButton! {
    didSet {
      bottomButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
    }
  }

  fileprivate var displayCollection: RegistrationConfirmDisplayCollection!
  var selectedEventId: Int = 0

  override func viewDidLoad() {
    super.viewDidLoad()

    assert(selectedEventId > 0, "Event id must be setup")

    navigationController?.setNavigationBarHidden(true, animated: true)
    bottomButton = BottomButton(addingOnView: view, title: "Закрыть".localized)
    displayCollection = RegistrationConfirmDisplayCollection()
    tableView.registerNibs(from: displayCollection)

    displayCollection.delegate = self
    displayCollection.event = mainRealm.objects(EventEntity.self).first(where: { $0.id == selectedEventId })

    if let event = displayCollection.event {
      displayCollection.updateActionCellsSection(on: self, with: tableView, event: event)
    }
  }

  func closeButtonAction() {
    // Setup default (previus) visibility for navigation bar
    navigationController?.setNavigationBarHidden(false, animated: false)
    // Go to main screen
    navigationController?.popToRootViewController(animated: true)
  }

  override func updateUI() {
    if let event = displayCollection.event {
      displayCollection.updateActionCellsSection(on: self, with: tableView, event: event)
    }
    super.updateUI()
  }
}

// MARK: - UITableViewDataSource
extension RegistrationConfirmViewController: UITableViewDataSource, UITableViewDelegate {
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

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return displayCollection.height(for: indexPath)
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    displayCollection.didSelect(indexPath: indexPath)
  }
}
