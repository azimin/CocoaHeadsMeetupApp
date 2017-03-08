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

  @IBOutlet weak var footerTableView: UIView!
  @IBOutlet weak var registrationButton: UIButton! {
    didSet {
      registrationButton.setTitle("registration".localized, for: .normal)
      registrationButton.tintColor = UIColor(red: 0.843, green: 0.243, blue: 0.412, alpha: 1.00)
      registrationButton.layer.cornerRadius = 10
      registrationButton.layer.borderWidth = 1
      registrationButton.layer.borderColor = registrationButton.tintColor.cgColor
    }
  }

  var dataCollection = RegistrationFieldData()

  override func viewDidLoad() {
    super.viewDidLoad()
    keyboardDelegate = self

    //Get test data from server
    let dataCollectionModel = RegistrationFieldDataCollection()
    dataCollectionModel.loadFieldsFromServer(complitionBlock: {
      DispatchQueue.main.async {
        self.dataCollection = dataCollectionModel.dataCollection
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
    let cell: TextFieldTableViewCell = (tableView.cellForRow(at: indexPath) as? TextFieldTableViewCell)!
    cell.textField.becomeFirstResponder()
  }

  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return footerTableView
  }

}

// MARK: - UITableViewDataSource
extension RegistrationPreviewViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return dataCollection.sections[section].title
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return dataCollection.sections.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataCollection.sections[section].fields.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let item = dataCollection.sections[indexPath.section].fields[indexPath.row]
    let cell = tableView.dequeueReusableCell(withItem: item, atIndexPath: indexPath)

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
      tableView.isScrollEnabled = true
      tableViewContnetInsets.bottom = info.endFrame.height
      indicatorContentInsets.bottom = info.endFrame.height
    case .hidden:
      tableView.isScrollEnabled = false
      tableViewContnetInsets.bottom = 0
      indicatorContentInsets.bottom = 0
    }

    tableView.contentInset = tableViewContnetInsets
    tableView.scrollIndicatorInsets = indicatorContentInsets
  }
}
