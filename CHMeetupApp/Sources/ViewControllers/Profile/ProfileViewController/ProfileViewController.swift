//
//  ProfileViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 22/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, ProfileHierarhyViewControllerType {

  @IBOutlet var tableView: UITableView!

  fileprivate var displayCollection: ProfileViewDisplayCollection!

  // MARK: - View Lifecycle.

  override func viewDidLoad() {
    super.viewDidLoad()
    displayCollection = ProfileViewDisplayCollection()
    tableView.registerNibs(from: displayCollection)

    title = displayCollection.user.fullName
    view.backgroundColor = UIColor(.lightGray)
  }

  // MARK: - Actions.

  @IBAction func logoutBarButtonAction(_ sender: UIBarButtonItem) {
    LoginProcessController.logout()
    profileNavigationController?.updateRootViewController()
  }

  @IBAction func editBarButtonAction(_ sender: UIBarButtonItem) {

  }
}

// MARK: - TableView Data Source.

extension ProfileViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return displayCollection.numberOfRows(in: section)
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = displayCollection.model(for: indexPath)
    let cell = tableView.dequeueReusableCell(for: indexPath, with: model)
    return cell
  }
}

// MARK: - TableView Delegate.

extension ProfileViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return displayCollection.cellHeightFor(indexPath)
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
