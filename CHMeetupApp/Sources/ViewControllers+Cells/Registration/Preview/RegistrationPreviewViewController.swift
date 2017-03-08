//
//  RegistrationPreviewViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 23/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class RegistrationPreviewViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.delegate = self
      tableView.dataSource = self

      let textFieldCellNib = TextFieldTableViewCell.nib
      let textFieldCellIdentifier = TextFieldTableViewCell.identifier
      tableView.register(textFieldCellNib, forCellReuseIdentifier: textFieldCellIdentifier)

      let radioCellNib = RadioTableViewCell.nib
      let radioCellIdentifier = RadioTableViewCell.identifier
      tableView.register(radioCellNib, forCellReuseIdentifier: radioCellIdentifier)

      let checkboxCellNib = CheckboxTableViewCell.nib
      let checkboxCellIdentifier = CheckboxTableViewCell.identifier
      tableView.register(checkboxCellNib, forCellReuseIdentifier: checkboxCellIdentifier)
    }
  }

  @IBOutlet weak var registrationButton: UIButton! {
    didSet {
      registrationButton.setTitle("registration".localized, for: .normal)
      registrationButton.backgroundColor = UIColor(red: 0.843, green: 0.243, blue: 0.412, alpha: 1.00)
      registrationButton.setTitleColor(UIColor.white, for: .normal)
    }
  }

  var dataCollection: FormData?

  override func viewDidLoad() {
    super.viewDidLoad()
    keyboardDelegate = self

    // FIXME: - Get test data from server
    FormDataCollection.loadRegFromServer(withId: "1", complitionBlock: { (form: EventRegFormPlainObject) in
      DispatchQueue.main.async {
        self.dataCollection = FormData(with: form)
        self.tableView.reloadData()
      }
    })

  }

  @IBAction func registrationButtonPressed(_ sender: UIButton) {
  }
}

// MARK: - UITableViewDelegate
extension RegistrationPreviewViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  }
}

// MARK: - UITableViewDataSource
extension RegistrationPreviewViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return dataCollection?.sections[section].name ?? ""
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return dataCollection?.sections.count ?? 0
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataCollection?.sections[section].fieldAnswers.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let item = dataCollection?.sections[indexPath.section].fieldAnswers[indexPath.row]
    let cell = tableView.dequeueReusableCell(with: item!, atIndexPath: indexPath)

    return cell
  }

}

// MARK: - KeyboardHandlerDelegate
extension RegistrationPreviewViewController: KeyboardHandlerDelegate {
  func keyboardStateChanged(input: UIView?, state: KeyboardState, info: KeyboardInfo) {

    var tableViewContnetInsets = tableView.contentInset
    var indicatorContentInsets = tableView.scrollIndicatorInsets

    switch state {
    case .frameChanged:
      tableViewContnetInsets.bottom = info.endFrame.height
      indicatorContentInsets.bottom = info.endFrame.height
    case .opened:
      tableViewContnetInsets.bottom = info.endFrame.height
      indicatorContentInsets.bottom = info.endFrame.height
    case .hidden:
      tableViewContnetInsets.bottom = 0
      indicatorContentInsets.bottom = 0
    }

    tableView.contentInset = tableViewContnetInsets
    tableView.scrollIndicatorInsets = indicatorContentInsets
  }
}
