//
//  ProfileEditViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 22/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class ProfileEditViewController: UIViewController, ProfileHierarhyViewControllerType {

  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.configure(with: .defaultConfiguration)
    }
  }

  fileprivate var displayCollection: ProfileEditDisplayCollection!

  override func viewDidLoad() {
    super.viewDidLoad()
    guard let user = UserPreferencesEntity.value.currentUser else {
      fatalError("Authorization error")
    }
    displayCollection = ProfileEditDisplayCollection()
    displayCollection.user = user

    displayCollection.delegate = self
    tableView.registerNibs(from: displayCollection)
    title = "Изменение профиля".localized
  }

}

// MARK: - TableViewDelegate
extension ProfileEditViewController: TableViewDelegate {
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
  }
}

// MARK: - ImagePicker
extension ProfileEditViewController: ImagePickerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    displayCollection.didReciveMedia(picker, info: info)
  }
}
