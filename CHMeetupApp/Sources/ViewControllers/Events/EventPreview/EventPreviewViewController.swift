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
    tableView.configure(with: .custom(configuration))

    if isRegistrationEnabled {
      bottomButton = BottomButton(addingOnView: view, title: "Я пойду".localized)
      bottomButton?.addTarget(self, action: #selector(acceptAction), for: .touchUpInside)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Event Preview".localized

    displayCollection = EventPreviewDisplayCollection()
    displayCollection.delegate = self
    tableView.registerNibs(from: displayCollection)

    let dataModel = DataModelCollection(type: EventEntity.self)
    displayCollection.event = dataModel.first(where: { $0.id == selectedEventId })

    if let event = displayCollection.event {
      fetchEvents(on: event)
      // FIXME: - Check on registation open
      isRegistrationEnabled = true
    }
  }

  func acceptAction() {
    let viewController = Storyboards.EventPreview.instantiateRegistrationPreviewViewController()
    navigationController?.pushViewController(viewController, animated: true)
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

extension EventPreviewViewController: EventPreviewDisplayCollectionDelegate {
  func displayCollectionRequestingUIUpdate() {
    tableView.reloadData()
  }

  func shouldPresentModalViewController(_ viewController: UIViewController) {
    present(viewController, animated: true, completion: nil)
  }
}

extension EventPreviewViewController {
  func fetchEvents(on eventEntity: EventEntity) {
    let speechesRequest = SpeechPlainObject.Requests.speechesOnEvent(with: selectedEventId)
    SpeechFetching.fetchElements(request: speechesRequest, to: eventEntity, completion: { [weak self] in
      self?.tableView.reloadData()
    })
  }
}
