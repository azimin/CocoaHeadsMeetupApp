//
//  EventPreviewViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 23/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

private let margin: CGFloat = 8

class EventPreviewViewController: UIViewController {
  @IBOutlet fileprivate var tableView: UITableView! {
    didSet {
      tableView.configure(topInset: margin, bottomInset: margin + BottomButton.constantHeight)
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
