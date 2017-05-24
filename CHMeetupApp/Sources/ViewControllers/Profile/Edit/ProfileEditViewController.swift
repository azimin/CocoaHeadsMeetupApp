//
//  ProfileEditViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 22/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class ProfileEditViewController: UIViewController, ProfileHierarhyViewControllerType {

  @IBOutlet fileprivate var tableView: UITableView! {
    didSet {
      let configuration = TableViewConfiguration(bottomInset: 8, estimatedRowHeight: 44)
      tableView.configure(with: .custom(configuration))
      tableView.registerHeaderNib(for: DefaultTableHeaderView.self)
    }
  }
  var bottomButton: BottomButton!
  fileprivate var displayCollection: ProfileEditDisplayCollection!

  override func viewDidLoad() {
    super.viewDidLoad()
    guard let user = UserPreferencesEntity.value.currentUser else {
      fatalError("Authorization error")
    }
    keyboardDelegate = self

    displayCollection = ProfileEditDisplayCollection()
    displayCollection.user = user

    displayCollection.delegate = self
    tableView.registerNibs(from: displayCollection)
    title = "Изменение профиля".localized

    bottomButton = BottomButton(addingOnView: view, title: "Сохранить".localized)
    bottomButton.addTarget(self, action: #selector(saveProfile), for: .touchUpInside)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    changeInsets(keyboardInset: 0)
  }

  fileprivate func changeInsets(keyboardInset: CGFloat) {
    var scrollViewContentInsets = tableView.contentInset
    var indicatorInsets = tableView.scrollIndicatorInsets
    var buttonInsets: CGFloat = 0

    let scrollViewBottomInset = keyboardInset + tableView.defaultBottomInset + bottomButton.frame.height
    scrollViewContentInsets.bottom = scrollViewBottomInset
    indicatorInsets.bottom = keyboardInset + bottomButton.frame.height
    buttonInsets = keyboardInset

    tableView.contentInset = scrollViewContentInsets
    tableView.scrollIndicatorInsets = indicatorInsets

    bottomButton.bottomInsetsConstant = buttonInsets
  }

}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension ProfileEditViewController: UITableViewDelegate, UITableViewDataSource {
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

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return displayCollection.headerHeight(for: section)
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView() as DefaultTableHeaderView
    header.headerLabel.text = displayCollection.headerTitle(for: section)
    return header
  }
}

// MARK: - ImagePicker
extension ProfileEditViewController: ImagePickerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    displayCollection.didReciveMedia(picker, info: info)
  }
}

// MARK: - KeyboardHandlerDelegate
extension ProfileEditViewController: KeyboardHandlerDelegate {

  func keyboardStateChanged(input: UIView?, state: KeyboardState, info: KeyboardInfo) {
    let insetToSet: CGFloat = (state == .hidden) ? 0 : info.endFrame.height
    changeInsets(keyboardInset: insetToSet)
    info.animate ({ [weak self] in
      self?.view.layoutIfNeeded()
    })
  }

}

extension ProfileEditViewController {
  func saveProfile() {
    if let failedFieldIndexPath = displayCollection.failedField {
      tableView.failedShakeRow(at: failedFieldIndexPath)
      return
    }

    displayCollection.update()
    ProfileController.save { success in
      if success {
        let notification = NotificationHelper.viewController(title: "Профиль изменён".localized,
                                          description: "Ваши прекрасные данные улетели на сервер.".localized,
                                          emjoi: "📋",
                                          completion: {
                                            self.navigationController?.popToRootViewController(animated: true)
        })

        self.present(viewController: notification)
      }
    }
  }
}
