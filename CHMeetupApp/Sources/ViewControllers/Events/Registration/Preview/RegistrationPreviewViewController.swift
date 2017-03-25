//
//  RegistrationPreviewViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 23/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class RegistrationPreviewViewController: UIViewController {

  @IBOutlet fileprivate var tableView: UITableView! {
    didSet {
      tableView.dataSource = self
    }
  }

  fileprivate var bottomButton: BottomButton!
  fileprivate var displayCollection: FormDisplayCollection?

  override func viewDidLoad() {
    super.viewDidLoad()
    keyboardDelegate = self

    bottomButton = BottomButton(addingOnView: view, title: "Регистрация".localized)
    bottomButton.addTarget(self, action: #selector(registrationButtonAction), for: .touchUpInside)

    // FIXME: - Remove test data
    RegistrationController.loadRegFromServer(
      with: 1,
      completion: { [weak self] displayCollection, error in

        guard error == nil else {
          print(error!)
          return
        }

        guard let displayCollection = displayCollection else {
          return
        }

        self?.displayCollection = displayCollection
        self?.tableView.reloadData()
    })
  }

  func registrationButtonAction() {
    registrate(completion: {
      presentRegistrationConfirmViewController()
    })
  }

  func registrate(completion: () -> Void) {
    // Do staff here..
    completion()
  }

  func presentRegistrationConfirmViewController() {
    let confirmViewController = Storyboards.EventPreview.instantiateRegistrationConfirmViewController()
    navigationController?.pushViewController(confirmViewController, animated: true)
  }
}

// MARK: - UITableViewDataSource
extension RegistrationPreviewViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return displayCollection?.headerTitle(for: section) ?? ""
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return displayCollection?.numberOfSections ?? 0
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return displayCollection?.numberOfRows(in: section) ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = displayCollection?.model(for: indexPath)
    let cell = tableView.dequeueReusableCell(for: indexPath, with: model!)
    return cell
  }
}

// MARK: - KeyboardHandlerDelegate
extension RegistrationPreviewViewController: KeyboardHandlerDelegate {

  func keyboardStateChanged(input: UIView?, state: KeyboardState, info: KeyboardInfo) {

    var buttonInsets: CGFloat = 0

    switch state {
    case .frameChanged, .opened:
      let tableViewBottomContentInsets = info.endFrame.height + bottomMargin + bottomButton.frame.height
      tableView.contentInset.bottom = tableViewBottomContentInsets
      tableView.scrollIndicatorInsets.bottom = info.endFrame.height + bottomButton.frame.height
      buttonInsets = info.endFrame.height
    case .hidden:
      tableView.contentInset.bottom = 0
      tableView.scrollIndicatorInsets.bottom = 0
      buttonInsets = 0
    }

    bottomButton.bottomInsetsConstant = buttonInsets
    info.animate({ [weak self] in
      self?.view.layoutIfNeeded()
    })
  }
}
