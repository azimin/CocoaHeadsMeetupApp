//
//  ProfileViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 22/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, ProfileHierarhyViewControllerType {

  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.configure(with: .defaultConfiguration)
    }
  }

  fileprivate var displayCollection: ProfileViewDisplayCollection!

  // MARK: - View Lifecycle.

  override func viewDidLoad() {
    super.viewDidLoad()
    displayCollection = ProfileViewDisplayCollection(delegate: self)
    tableView.registerNibs(from: displayCollection)

    title = displayCollection.user.fullName
  }

  // MARK: - Actions.

  @IBAction func logoutBarButtonAction(_ sender: UIBarButtonItem) {
    LoginProcessController.logout()
    profileNavigationController?.updateRootViewController()
  }

  @IBAction func editBarButtonAction(_ sender: UIBarButtonItem) {
    let viewController = Storyboards.Profile.instantiateProfileEditViewController()
    push(viewController: viewController)
  }
}

// MARK: - TableViewDelegate
extension ProfileViewController: TableViewDelegate {

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
