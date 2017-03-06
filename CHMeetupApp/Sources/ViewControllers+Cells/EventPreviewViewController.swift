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

  var nib: UINib? {
    switch self {
    case .infoAboutSpeechTableViewCell:
      return SpeechDetailsTableViewCell.nib
    case .infoAboutEventTableViewCell:
      return InfoAboutEventTableViewCell.nib
    case .addressButttonTableViewCell:
      return UINib(nibName: "AddressButtonTableViewCell", bundle: nil)
    case .addToCalendarButtonTableViewCell:
      return UINib(nibName: "AddToCalendarButtonTableViewCell", bundle: nil)
    case .addToReminderButtonTableViewCell:
      return UINib(nibName: "AddToReminderButtonTableViewCell", bundle: nil)
    case .joinButtonTableViewCell:
      return  UINib(nibName: "JoinButtonTableViewCell", bundle: nil)
    }
  }

  var identifier: String {
    switch self {
    case .infoAboutEventTableViewCell:
      return InfoAboutEventTableViewCell.identifier
    case .infoAboutSpeechTableViewCell:
      return SpeechDetailsTableViewCell.identifier
    case .addressButttonTableViewCell:
      return "AddressButtonTableViewCell"
    case .addToCalendarButtonTableViewCell:
      return "AddToCalendarButtonTableViewCell"
    case .addToReminderButtonTableViewCell:
      return "AddToReminderButtonTableViewCell"
    case .joinButtonTableViewCell:
      return "JoinButtonTableViewCell"
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
      cell.configure(with: EventEntity())
      return cell

    case .addressButttonTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: TypeOfCells.addressButttonTableViewCell.identifier)
        as! ActionButtonTableViewCell
      return cell

    case .addToCalendarButtonTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: TypeOfCells.addToCalendarButtonTableViewCell.identifier)
        as! ActionButtonTableViewCell
      cell.actionByTap = { cell in
        Importer.import(event: EventEntity(), to: .calendar,
                        completion: { Result in
                          ImportResultHandler.result(type: Result, in: self)
        })
      }
      return cell

    case .addToReminderButtonTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: TypeOfCells.addToReminderButtonTableViewCell.identifier)
        as! ActionButtonTableViewCell
      cell.actionByTap = { cell in
        Importer.import(event: EventEntity(), to: .reminder,
                        completion: { Result in
                          ImportResultHandler.result(type: Result, in: self)
        })
      }
      return cell

    case .joinButtonTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: TypeOfCells.joinButtonTableViewCell.identifier)
        as! ActionButtonTableViewCell
      cell.actionByTap = { cell in
        self.goToRegistrationPreview()
      }
      return cell

    case .infoAboutSpeechTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: SpeechDetailsTableViewCell.identifier)
        as! SpeechDetailsTableViewCell
      cell.configure(with: getItem(from: EventEntity()))
      return cell
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch groupTypeForCreate[indexPath.row] {
    case .infoAboutSpeechTableViewCell:
      self.goToSpeechPreview()
    default: break
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }

  func  goToSpeechPreview() {
    let storyboard = UIStoryboard(name: "EventPreview", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "SpeechViewController")
    self.navigationController?.pushViewController(viewController, animated: true)
  }

  func goToRegistrationPreview() {
    let storyboard = UIStoryboard(name: "EventPreview", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "RegistrationPreviewViewController")
    self.navigationController?.pushViewController(viewController, animated: true)
  }

  private func getItem(from: EventEntity) -> EventPreviewPO {
    let createPO = EventPreviewEntity()
    return createPO.eventPreviewEntityCollection(get: from)
  }
}
