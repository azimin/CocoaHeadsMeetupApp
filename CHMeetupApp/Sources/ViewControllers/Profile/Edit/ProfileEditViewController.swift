//
//  ProfileEditViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 22/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class ProfileEditViewController: UIViewController, ProfileHierarhyViewControllerType {

  var canSkip: Bool = true

  @IBOutlet var tableView: UITableView! {
    didSet {
      let configuration = TableViewConfiguration(
        bottomInset: 12 + BottomButton.constantHeight,
        bottomIndicatorInset: BottomButton.constantHeight,
        estimatedRowHeight: 44
      )
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
    displayCollection = ProfileEditDisplayCollection(canSkip: canSkip)
    displayCollection.user = user

    displayCollection.delegate = self
    tableView.registerNibs(from: displayCollection)
    title = "Изменение профиля".localized

    bottomButton = BottomButton(addingOnView: view, title: "Сохранить".localized)
    bottomButton.bottomInsetsConstant = 8.0
    bottomButton.addTarget(self, action: #selector(saveProfile), for: .touchUpInside)

    tableView.registerHeaderNib(for: DefaultTableHeaderView.self)

    if !canSkip {
      title = "Завершение регистрации".localized
      let logoutButton = UIBarButtonItem(image: #imageLiteral(resourceName: "img_log_out"),
                                         landscapeImagePhone: nil,
                                         style: .plain,
                                         target: self,
                                         action: #selector(logout))

      navigationItem.leftBarButtonItem = logoutButton
    }
  }

  @objc func logout() {
    profileNavigationController?.logout()
    navigationController?.popViewController(animated: true)
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

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return displayCollection.height(for: indexPath)
  }
}

// MARK: - ImagePicker
extension ProfileEditViewController: ImagePickerDelegate {
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String: Any]) {
    displayCollection.didReciveMedia(picker, info: info)
  }
}

// MARK: - KeyboardHandlerDelegate
extension ProfileEditViewController: KeyboardHandlerDelegate {
  func keyboardStateChanged(input: UIView?, state: KeyboardState, info: KeyboardInfo) {

    var scrollViewContentInsets = tableView.contentInset
    var indicatorInsets = tableView.scrollIndicatorInsets
    var buttonInsets: CGFloat = 0

    switch state {
    case .frameChanged, .opened:
      let scrollViewBottomInset = info.endFrame.height + tableView.defaultBottomInset + bottomButton.frame.height
      scrollViewContentInsets.bottom = scrollViewBottomInset
      indicatorInsets.bottom = info.endFrame.height + bottomButton.frame.height
      buttonInsets = info.endFrame.height + 8
    case .hidden:
      scrollViewContentInsets.bottom = 0
      indicatorInsets.bottom = 0
      buttonInsets = 8
    }

    tableView.contentInset = scrollViewContentInsets
    tableView.scrollIndicatorInsets = indicatorInsets

    bottomButton.bottomInsetsConstant = buttonInsets
    info.animate ({ [weak self] in
      self?.view.layoutIfNeeded()
    })
  }
}

extension ProfileEditViewController {
  @objc func saveProfile() {
    if let failedFieldIndexPath = displayCollection.failedField {
      tableView.failedShakeRow(failedFieldIndexPath)
      return
    }
    showProgressHUD()
    displayCollection.update()
    tableView.endEditing(true)
    ProfileController.save { [weak self] success in
      if success, let strongSelf = self {
        let message = "Ваши прекрасные данные успешно обновлены.".localized
        let notification = NotificationHelper.viewController(title: "Профиль изменён".localized,
                                                             description: message,
                                                             emoji: "📋",
                                                             completion: {
            strongSelf.navigationController?.popToRootViewController(animated: true)
        })

        self?.present(viewController: notification)
      } else {
        let notification = NotificationHelper.somethingWrongViewController()

        self?.present(viewController: notification)
      }
      self?.dismissProgressHUD()
    }
  }
}
