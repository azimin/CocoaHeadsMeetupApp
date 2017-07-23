//
//  EventPreviewViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 23/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class EventPreviewViewController: UIViewController {

  var selectedEventId: Int = 0

  @IBOutlet fileprivate var tableView: UITableView! {
    didSet {
      updateBottomButton()
    }
  }

  var isRegistrationEnabled: Bool = false {
    didSet {
      updateBottomButton()
    }
  }

  var bottomButton: BottomButton?
  var displayCollection: EventPreviewDisplayCollection!

  func updateBottomButton() {
    bottomButton?.removeFromSuperview()

    var configuration = TableViewConfiguration.default
    configuration.bottomInset = 8 + (isRegistrationEnabled ? BottomButton.constantHeight : 0)
    configuration.bottomIndicatorInset = (isRegistrationEnabled ? BottomButton.constantHeight : 0)
    tableView.configure(with: .custom(configuration))

    if isRegistrationEnabled {
      bottomButton = BottomButton(addingOnView: view, title: "Я пойду".localized)
      bottomButton?.addTarget(self, action: #selector(acceptAction), for: .touchUpInside)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Встреча".localized

    view.backgroundColor = UIColor(.lightGray)

    displayCollection = EventPreviewDisplayCollection()
    displayCollection.delegate = self
    tableView.registerNibs(from: displayCollection)

    let dataModel = DataModelCollection(type: EventEntity.self)
    displayCollection.event = dataModel.first(where: { $0.id == selectedEventId })
    if let event = displayCollection.event {
      fetchSpeeches(on: event)
      displayCollection.updateActionCellsSection(on: self, with: tableView, event: event)
      bottomButton?.setTitle(event.status.statusText, for: .normal)
      isRegistrationEnabled = event.status.allowRegister
    }
  }

  func acceptAction() {
    let viewController = ViewControllersFactory.eventRegistrationOrAuthViewController(
      eventId: selectedEventId
    )
    navigationController?.pushViewController(viewController, animated: true)
  }

  override func updateUI() {
    if let event = displayCollection.event {
      displayCollection.updateActionCellsSection(on: self, with: tableView, event: event)
    }
    super.updateUI()
  }
}

extension EventPreviewViewController: UITableViewDelegate, UITableViewDataSource {

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

extension EventPreviewViewController {
  func fetchSpeeches(on eventEntity: EventEntity) {
    displayCollection.speeches.isLoading = true
    let speechesRequest = SpeechPlainObject.Requests.speechesOnEvent(with: selectedEventId)
    SpeechFetching.fetchElements(request: speechesRequest, to: eventEntity, completion: { [weak self] in
      self?.displayCollection.speeches.isLoading = false
      self?.tableView.reloadData()
    })
  }
}
