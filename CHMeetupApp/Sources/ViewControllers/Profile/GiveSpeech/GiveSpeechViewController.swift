//
//  GiveSpeechViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 23/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class GiveSpeechViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet var tableView: UITableView! {
    didSet {
      let configuration = TableViewConfiguration(bottomInset: 12 + BottomButton.constantHeight,
                                                 bottomIndicatorInset: 8.0 + BottomButton.constantHeight,
                                                 estimatedRowHeight: 44)
      tableView.configure(with: .custom(configuration))
      tableView.registerHeaderNib(for: DefaultTableHeaderView.self)
    }
  }

  var displayCollection: GiveSpeechDisplayCollection!
  var bottomButton: BottomButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    keyboardDelegate = self
    setupGestureRecognizer()

    displayCollection = GiveSpeechDisplayCollection()
    tableView.registerNibs(from: displayCollection)

    navigationItem.title = "Стать спикером".localized

    bottomButton = BottomButton(addingOnView: view, title: "Подать заявку".localized)
    bottomButton.bottomInsetsConstant = 8.0
    bottomButton.addTarget(self, action: #selector(sendSpeech), for: .touchUpInside)
  }

  func setupGestureRecognizer() {
    let dissmisKeyboardTouch =
      UITapGestureRecognizer(target: self,
                             action: #selector(GiveSpeechViewController.dismissKeyboard))
    view.addGestureRecognizer(dissmisKeyboardTouch)
  }

  @objc func sendSpeech() {

    if let failed = displayCollection.failedSection {
      tableView.failedShakeSection(failed)
      return
    }

    GiveSpeechController.sendRequest(title: displayCollection.nameText,
                                     description: displayCollection.descriptionText) { [weak self] success in
      if success {
        self?.tableView.endEditing(true)
        let notification = NotificationHelper.viewController(title: "Прекрасно!".localized,
                                                             description: "Ваша великолепная заявка отправлена.".localized,
                                                             emoji: "📦",
                                                             completion: {
                                                              self?.navigationController?.popToRootViewController(animated: true)
        })
        self?.present(viewController: notification)
      } else {
        let notification = NotificationHelper.somethingWrongViewController()
        
        self?.present(viewController: notification)
      }
    }
  }

  @objc func dismissKeyboard() {
    view.endEditing(true)
  }

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

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return displayCollection.height(for: indexPath)
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

// MARK: - KeyboardHandlerDelegate
extension GiveSpeechViewController: KeyboardHandlerDelegate {
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
      buttonInsets = 8.0
    }

    tableView.contentInset = scrollViewContentInsets
    tableView.scrollIndicatorInsets = indicatorInsets

    bottomButton.bottomInsetsConstant = buttonInsets
    info.animate ({ [weak self] in
      self?.view.layoutIfNeeded()
    })
  }
}
