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
      
      let selectOneCellNib = SelectOneTableViewCell.nib
      let selectOneCellIdentifier = SelectOneTableViewCell.identifier
      tableView.register(selectOneCellNib, forCellReuseIdentifier: selectOneCellIdentifier)
      
      let selectMultiplyCellNib = SelectMultiplyTableViewCell.nib
      let selectMultiplyCellIdentifier = SelectMultiplyTableViewCell.identifier
      tableView.register(selectMultiplyCellNib, forCellReuseIdentifier: selectMultiplyCellIdentifier)
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

  var dataCollection = RegistrationPreviewDataCollection().dataCollection

  override func viewDidLoad() {
    super.viewDidLoad()
    keyboardDelegate = self
  }

  @IBAction func registrationButtonPressed(_ sender: UIButton) {
    // Do some staff
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
    return ""//dataCollection.sections[section].title
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1//dataCollection.sections.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3//dataCollection.sections[section].fields.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = TextFieldTableViewCell.identifier
    let cell: TextFieldTableViewCell =
      (tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? TextFieldTableViewCell)!

    cell.textField.placeholder = "test"
    // For recognazion in delegate methods
    cell.textField.tag = indexPath.row
    cell.textField.delegate = self
    cell.selectionStyle = .none

    return cell
  }

}

// MARK: - UITextFieldDelegate
//extension RegistrationPreviewViewController {
//  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//    let nextCellIndex = textField.tag + 1
//    // Ask model if has next cell
//    // just for example
//    let hasNextCell = (nextCellIndex <= 6)
//    if hasNextCell {
//      let nextCellIndexPath = IndexPath(row: nextCellIndex, section: 0)
//      let cell: TextFieldTableViewCell =
//        (tableView.cellForRow(at: nextCellIndexPath) as? TextFieldTableViewCell)!
//      cell.textField.becomeFirstResponder()
//      return false
//    }
//    return true
//  }
//}

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
