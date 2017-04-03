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
      var configuration = TableViewConfiguration.default
      configuration.bottomInset = 8 + BottomButton.constantHeight
      tableView.configure(with: .custom(configuration))
    }
  }

  var bottomButton: BottomButton!
  var displayCollection: EventPreviewDisplayCollection!

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Event Preview".localized
    view.backgroundColor = UIColor(.lightGray)
    bottomButton = BottomButton(addingOnView: view, title: "Я пойду".localized)
    bottomButton.addTarget(self, action: #selector(acceptAction), for: .touchUpInside)

    displayCollection = EventPreviewDisplayCollection()
    displayCollection.delegate = self

    tableView.registerNibs(from: displayCollection)

    displayCollection.event = mainRealm.objects(EventEntity.self).first(where: { $0.id == selectedEventId })
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
}
