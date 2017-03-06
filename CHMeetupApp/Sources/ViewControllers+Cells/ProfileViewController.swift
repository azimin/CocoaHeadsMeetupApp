//
//  ProfileViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 22/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

struct Cells {
  struct Profile {
    static let picture =  "ProfilePictureCell"
    static let name =     "ProfileNameCell"
    static let speach =   "ProfileSpeachCell"
  }
}

struct CellHeights {
  struct Profile {
    static let picture =  CGFloat(104.0)
    static let name =     CGFloat(63.0)
    static let speach =   CGFloat(37.0)
  }
}

enum ProfileCells {
  case picture, name, speach
}

class ProfileViewController: UIViewController, ProfileHierarhyViewControllerType {

  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.tableFooterView = UIView()
      tableView.register(UINib.init(nibName: Cells.Profile.picture, bundle: nil),
                         forCellReuseIdentifier: Cells.Profile.picture)
      tableView.register(UINib.init(nibName: Cells.Profile.name, bundle: nil),
                         forCellReuseIdentifier: Cells.Profile.name)
      tableView.register(UINib.init(nibName: Cells.Profile.speach, bundle: nil),
                         forCellReuseIdentifier: Cells.Profile.speach)
    }
  }

  var tableArray = [ProfileCells]()

  // MARK: - View Lifecycle.

  override func viewDidLoad() {
    super.viewDidLoad()
    updateTableView()
  }

  // MARK: - TableView update.

  func updateTableView() {
    tableArray = [.picture, .name, .speach]
    tableView.reloadData()
  }

  // MARK: - Actions.

  @IBAction func logutBarButtonAction(_ sender: UIBarButtonItem) {
    LoginProcessViewController.isLogin = false
    profileNavigationController?.updateRootViewController()
  }

  @IBAction func editBarButtonAction(_ sender: UIBarButtonItem) {

  }

  // MARK: - Table helpers.

  func cellHeightFor(_ indexPath: IndexPath) -> CGFloat {
    switch tableArray[indexPath.row] {
    case .picture:
      return CellHeights.Profile.picture
    case .name:
      return CellHeights.Profile.name
    case .speach:
      return CellHeights.Profile.speach
    }
  }

  func cellObjectFor(_ indexPath: IndexPath) -> UITableViewCell {
    var cell: UITableViewCell!
    switch tableArray[indexPath.row] {
    case .picture:
      cell = tableView.dequeueReusableCell(withIdentifier: Cells.Profile.picture, for: indexPath)
    case .name:
      cell = tableView.dequeueReusableCell(withIdentifier: Cells.Profile.name, for: indexPath)
    case .speach:
      cell = tableView.dequeueReusableCell(withIdentifier: Cells.Profile.speach, for: indexPath)
    }
    return cell
  }

  func cellActionFor(_ indexPath: IndexPath) {
    switch tableArray[indexPath.row] {
    case .speach:
      let giveSpeachViewController = Storyboards.Profile.instantiateGiveSpeechViewController()
      if let navigationController = navigationController {
        navigationController.pushViewController(giveSpeachViewController,
                                                animated: true)
      }
    case .name, .picture:
      return
    }
  }

}

// MARK: - TableView Data Source.

extension ProfileViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableArray.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return cellObjectFor(indexPath)
  }
}

// MARK: - TableView Delegate.

extension ProfileViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return cellHeightFor(indexPath)
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    cellActionFor(indexPath)
  }
}
