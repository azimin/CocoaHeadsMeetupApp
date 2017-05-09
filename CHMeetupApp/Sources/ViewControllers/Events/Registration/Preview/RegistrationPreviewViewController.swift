//
//  RegistrationPreviewViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 23/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class RegistrationPreviewViewController: UIViewController, DisplayCollectionWithTableViewDelegate {

  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.allowsMultipleSelection = true
      let configuration = TableViewConfiguration(
                                      bottomInset: 8 + BottomButton.constantHeight,
                                      bottomIndicatorInset: BottomButton.constantHeight,
                                      estimatedRowHeight: 44)
      tableView.configure(with: .custom(configuration))
      tableView.registerHeaderNib(for: DefaultTableHeaderView.self)
    }
  }

  fileprivate var bottomButton: BottomButton! {
    didSet {
      bottomButton.addTarget(self, action: #selector(registrationButtonAction), for: .touchUpInside)
    }
  }

  fileprivate var displayCollection: FormDisplayCollection!

  override func viewDidLoad() {
    super.viewDidLoad()

    assert(selectedEventId > 0, "Event id must be setup")

    keyboardDelegate = self

    title = "Регистрация".localized

    bottomButton = BottomButton(addingOnView: view, title: "Зарегистрироваться".localized)
    bottomButton.isEnabled = false

    displayCollection = FormDisplayCollection()
    tableView.registerNibs(from: displayCollection)

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
        self?.displayCollection.delegate = self
        self?.displayCollection.displayCollectionWithTableViewDelegate = self

        DispatchQueue.main.async {
          self?.bottomButton.isEnabled = true
          self?.tableView.reloadData()
        }

    })

    setupGestureRecognizer()
  }

  var dissmisKeyboardTouch: UITapGestureRecognizer!
  var selectedEventId: Int = 0

  func setupGestureRecognizer() {
    dissmisKeyboardTouch =
      UITapGestureRecognizer(target: self,
                             action: #selector(GiveSpeechViewController.dismissKeyboard))
    view.addGestureRecognizer(dissmisKeyboardTouch)
    dissmisKeyboardTouch.isEnabled = false
  }

  func dismissKeyboard() {
    view.endEditing(true)
  }

  func registrationButtonAction() {
    guard displayCollection.isFormLoaded else {
      fatalError("\(#function): form is not loaded")
    }
    if let failedSection = displayCollection.failedSection {
      showFailed(for: failedSection)
    } else {
      registrate()
    }
  }

  func registrate() {
    RegistrationController.sendFormData(displayCollection.formData, completion: { [weak self] success in
      if success {
        let dataModel = DataModelCollection(type: EventEntity.self)
        let event = dataModel.first(where: { $0.id == self?.selectedEventId })
        realmWrite {
          event?.statusValue = EventEntity.EventRegistrationStatus.waiting.rawValue
        }
        self?.presentRegistrationConfirmViewController()
      } else {
        self?.showMessageAlert(title: "Возникла ошибка".localized)
      }
    })
  }

  func presentRegistrationConfirmViewController() {
    let confirmViewController = Storyboards.EventPreview.instantiateRegistrationConfirmViewController()
    confirmViewController.selectedEventId = selectedEventId
    self.push(viewController: confirmViewController)
  }
}

// MARK: - UITableViewDataSource
extension RegistrationPreviewViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return displayCollection.headerHeight(for: section)
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView() as DefaultTableHeaderView
    header.headerLabel.attributedText = displayCollection.headerTitle(for: section)
    return header
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
}

extension RegistrationPreviewViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    displayCollection.didSelect(indexPath: indexPath)
  }

  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    displayCollection.didSelect(indexPath: indexPath)
  }
}

extension RegistrationPreviewViewController: FormDisplayCollectionDelegate {
  func formDisplayRequestTo(selectItemsAt selectionIndexPaths: [IndexPath],
                            deselectItemsAt deselectIndexPaths: [IndexPath]) {
    for indexPath in selectionIndexPaths {
      tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
    }
    for indexPath in deselectIndexPaths {
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }

  func formDisplayRequestCell(at indexPath: IndexPath) -> UITableViewCell? {
    return tableView.cellForRow(at: indexPath)
  }

  func formDisplayRequestTouchGeuster(enable: Bool) {
    dissmisKeyboardTouch.isEnabled = enable
  }

  func showFailed(for section: Int) {
    let indexPath = IndexPath(row: 0, section: section)
    tableView.scrollToRow(at: indexPath, at: .top, animated: true)

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
      self.tableView.failedShakeSection(section)
    }
  }
}

// MARK: - KeyboardHandlerDelegate

extension RegistrationPreviewViewController: KeyboardHandlerDelegate {

  func keyboardStateChanged(input: UIView?, state: KeyboardState, info: KeyboardInfo) {

    var buttonInsets: CGFloat = 0

    switch state {
    case .frameChanged, .opened:
      // 15 is necessary offset due to the feature of the projected cell
      let tableViewBottomContentInsets = info.endFrame.height + 15 + tableView.defaultBottomInset
      tableView.contentInset.bottom = tableViewBottomContentInsets
      tableView.scrollIndicatorInsets.bottom = info.endFrame.height + bottomButton.frame.height
      buttonInsets = info.endFrame.height
    case .hidden:
      tableView.contentInset.bottom = tableView.defaultBottomInset
      tableView.scrollIndicatorInsets.bottom = BottomButton.constantHeight
      buttonInsets = 0
    }

    bottomButton.bottomInsetsConstant = buttonInsets
    info.animate({ [weak self] in
      self?.view.layoutIfNeeded()
    })
  }
}
