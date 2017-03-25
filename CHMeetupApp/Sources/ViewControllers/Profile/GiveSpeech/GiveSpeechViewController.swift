//
//  GiveSpeechViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 23/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class GiveSpeechViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet var tableView: UITableView!

  var displayCollection: GiveSpeechDisplayCollection!
  var bottomButton: BottomButton!

  @IBOutlet weak var sendSpeechButton: UIBarButtonItem!

  override func viewDidLoad() {
    super.viewDidLoad()

    keyboardDelegate = self
    setupGestureRecognizer()

    displayCollection = GiveSpeechDisplayCollection()

    view.backgroundColor = UIColor(.lightGray)
    title = "Geve a speech".localized

    bottomButton = BottomButton(addingOnView: view, title: "Подать заявку".localized)
    bottomButton.addTarget(self, action: #selector(sendSpeech), for: .touchUpInside)
  }

  func setupGestureRecognizer() {
    let dissmisKBTouch =
      UITapGestureRecognizer(target: self,
                             action: #selector(GiveSpeechViewController.dismissKeyboard))
    view.addGestureRecognizer(dissmisKBTouch)
  }

  func sendSpeech() {
    print(displayCollection.nameText, displayCollection.descriptionText)
    // Do stuff here ...
  }

  @IBAction func sendSpeechButtonPressed(_ sender: UIBarButtonItem) {
    sendSpeech()
  }

  func dismissKeyboard() {
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

    var scrollViewContnetInsets = tableView.contentInset
    var indicatorContentInsets = tableView.scrollIndicatorInsets
    var buttonInsets: CGFloat = 0

    switch state {
    case .frameChanged, .opened:
      let scrollViewContentInsets = info.endFrame.height + tableView.defaultBottomInset + bottomButton.frame.height
      scrollViewContnetInsets.bottom = scrollViewContentInsets
      indicatorContentInsets.bottom = info.endFrame.height + bottomButton.frame.height
      buttonInsets = info.endFrame.height
    case .hidden:
      scrollViewContnetInsets.bottom = 0
      indicatorContentInsets.bottom = 0
      buttonInsets = 0
    }

    tableView.contentInset = scrollViewContnetInsets
    tableView.scrollIndicatorInsets = indicatorContentInsets

    info.animate ({ [weak self] in
      self?.bottomButton.bottomInsetsConstant = buttonInsets
      self?.view.layoutIfNeeded()
    })
  }
}
