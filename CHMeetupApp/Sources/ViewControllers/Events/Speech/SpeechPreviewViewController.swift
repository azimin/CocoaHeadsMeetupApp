//
//  SpeechPreviewViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 23/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class SpeechPreviewViewController: UIViewController {

  var selectedSpeechId: Int = 0

  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.configure(with: .defaultConfiguration)
    }
  }

  var displayCollection: SpeechPreviewDisplayCollection!

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Speech".localized
    view.backgroundColor = UIColor(.lightGray)

    displayCollection = SpeechPreviewDisplayCollection()
    displayCollection.delegate = self
    tableView.registerNibs(from: displayCollection)

    let dataModel = DataModelCollection(type: SpeechEntity.self)
    displayCollection.speech = dataModel.first(where: { $0.id == selectedSpeechId })
  }
}

extension SpeechPreviewViewController: UITableViewDelegate, UITableViewDataSource {

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
