//
//  EventPreviewViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 23/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

enum TypeOfCells {
  case infoAboutSpeechTableViewCell
  case infoAboutEventTableViewCell
  case addressButttonTableViewCell
  case addToCalendarButtonTableViewCell
  case addToReminderButtonTableViewCell
  case joinButtonTableViewCell

  var nib: UINib {
    switch self {
    case .infoAboutSpeechTableViewCell:
      return SpeechDetailsTableViewCell.nib
    case .infoAboutEventTableViewCell:
      return InfoAboutEventTableViewCell.nib
    case .addressButttonTableViewCell:
      return AddressButtonTableViewCell.nib
    case .addToCalendarButtonTableViewCell:
      return AddToCalendarButtonTableViewCell.nib
    case .addToReminderButtonTableViewCell:
      return AddToReminderButtonTableViewCell.nib
    case .joinButtonTableViewCell:
      return JoinButtonTableViewCell.nib
    }
  }

  var identifier: String {
    switch self {
    case .infoAboutEventTableViewCell:
      return InfoAboutEventTableViewCell.identifier
    case .infoAboutSpeechTableViewCell:
      return SpeechDetailsTableViewCell.identifier
    case .addressButttonTableViewCell:
      return AddressButtonTableViewCell.identifier
    case .addToCalendarButtonTableViewCell:
      return AddToCalendarButtonTableViewCell.identifier
    case .addToReminderButtonTableViewCell:
      return AddToReminderButtonTableViewCell.identifier
    case .joinButtonTableViewCell:
      return JoinButtonTableViewCell.identifier
    }
  }
}

let groupTypeForRegister: [TypeOfCells] = [ .infoAboutEventTableViewCell,
                                 .addressButttonTableViewCell,
                                 .addToCalendarButtonTableViewCell,
                                 .addToReminderButtonTableViewCell,
                                 .infoAboutSpeechTableViewCell,
                                 .joinButtonTableViewCell]

let groupTypeForCreate: [TypeOfCells] = [.infoAboutEventTableViewCell,
                                         .addressButttonTableViewCell,
                                         .addToCalendarButtonTableViewCell,
                                         .addToReminderButtonTableViewCell,
                                         .infoAboutSpeechTableViewCell,
                                         .infoAboutSpeechTableViewCell,
                                         .infoAboutSpeechTableViewCell,
                                         .joinButtonTableViewCell]

class EventPreviewViewController: UIViewController {
  static fileprivate let eventPreviewEnitityPO = EventPreviewEntity()

  @IBOutlet var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.separatorStyle = .none
    tableView.estimatedRowHeight = 40
    tableView.rowHeight = UITableViewAutomaticDimension
    for typeOfCell in groupTypeForRegister {
      self.tableView.register(typeOfCell.nib, forCellReuseIdentifier: typeOfCell.identifier)
    }
  }
}

extension EventPreviewViewController: UITableViewDataSource, UITableViewDelegate {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return groupTypeForCreate.count
  }

  // swiftlint:disable colon:next force_cast
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch groupTypeForCreate[indexPath.row] {
    case .infoAboutEventTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: InfoAboutEventTableViewCell.identifier)
        as! InfoAboutEventTableViewCell
      cell.configure(with: EventPO())
      return cell

    case .addressButttonTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: AddressButtonTableViewCell.identifier)
        as! AddressButtonTableViewCell
      return cell

    case .addToCalendarButtonTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: AddToCalendarButtonTableViewCell.identifier)
        as! AddToCalendarButtonTableViewCell
      cell.actionByTap = { cell in
        Importer.import(event: EventPO(), to: .calendar,
                        completion: { Result in ImportResultHandler.result(type: Result, in: self)})}
      return cell

    case .addToReminderButtonTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: AddToReminderButtonTableViewCell.identifier)
        as! AddToReminderButtonTableViewCell
      cell.actionByTap = { cell in
        Importer.import(event: EventPO(), to: .reminder,
                        completion: { Result in ImportResultHandler.result(type: Result, in: self)})}
      return cell

    case .joinButtonTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: JoinButtonTableViewCell.identifier)
        as! JoinButtonTableViewCell
      cell.actionByTap = { cell in
        let storyboard = UIStoryboard(name: "EventPreview", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RegistrationPreviewViewController")
        self.navigationController?.pushViewController(viewController, animated: true)}
      return cell

    case .infoAboutSpeechTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: SpeechDetailsTableViewCell.identifier)
        as! SpeechDetailsTableViewCell
      cell.configure(with: getItem())
      return cell
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch groupTypeForCreate[indexPath.row] {
    case .infoAboutSpeechTableViewCell:
      goToSpeechPreview()
    default: break
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }

  func  goToSpeechPreview() {
    let storyboard = UIStoryboard(name: "EventPreview", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "SpeechViewController")
    self.navigationController?.pushViewController(viewController, animated: true)
  }

  private func getItem() -> EventPreviewPO {
    return EventPreviewPO(speechDetails: "Goood Speech")
    // FIXME: - Right value
//    return EventPreviewViewController.eventPreviewEnitityPO.eventPreviewEntityCollection()
  }
}
