//
//  EventPreviewViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 23/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

enum TypeOfCells {
  case speechDetailsTableViewCell
  case eventDetailsTableViewCell
  case addressButttonTableViewCell
  case addToCalendarButtonTableViewCell
  case addToReminderButtonTableViewCell
  case joinButtonTableViewCell

  var nib: UINib? {
    switch self {
    case .speechDetailsTableViewCell:
      return SpeechDetailsTableViewCell.nib
    case .eventDetailsTableViewCell:
      return InfoAboutEventTableViewCell.nib
    case .addressButttonTableViewCell,
         .addToCalendarButtonTableViewCell,
         .addToReminderButtonTableViewCell,
         .joinButtonTableViewCell:
      return ActionButtonTableViewCell.nib
    }
  }

  var identifier: String {
    switch self {
    case .eventDetailsTableViewCell:
      return InfoAboutEventTableViewCell.identifier
    case .speechDetailsTableViewCell:
      return SpeechDetailsTableViewCell.identifier
    case .addressButttonTableViewCell,
         .addToCalendarButtonTableViewCell,
         .addToReminderButtonTableViewCell,
         .joinButtonTableViewCell:
      return ActionButtonTableViewCell.identifier
    }
  }
}

let groupTypeForRegister: [TypeOfCells] = [ .eventDetailsTableViewCell,
                                            .addressButttonTableViewCell,
                                            .speechDetailsTableViewCell]

let groupTypeForCreate: [TypeOfCells] = [.eventDetailsTableViewCell,
                                         .addressButttonTableViewCell,
                                         .addToCalendarButtonTableViewCell,
                                         .addToReminderButtonTableViewCell,
                                         .speechDetailsTableViewCell,
                                         .joinButtonTableViewCell]

class EventPreviewViewController: UIViewController {

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

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch groupTypeForCreate[indexPath.row] {
    case .speechDetailsTableViewCell:
      self.goToSpeechPreview()
    default: break
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let actionButtonCell = tableView.dequeueReusableCell(withIdentifier: "ActionButtonTableViewCell")
      as! ActionButtonTableViewCell

    switch groupTypeForCreate[indexPath.row] {
    case .eventDetailsTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: TypeOfCells.eventDetailsTableViewCell.identifier)
      as! InfoAboutEventTableViewCell
      cell.configure(with: EventEntity())
      return cell

    case .speechDetailsTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: TypeOfCells.speechDetailsTableViewCell.identifier)
      as! SpeechDetailsTableViewCell
      cell.configure(with: getItem(from: EventEntity(), at: indexPath.row))
      return cell

    case .addressButttonTableViewCell:
      actionButtonCell.addAction(title: "Address".localized, handler: { _ in
      print("showMap")
      })
      return actionButtonCell

    case .addToCalendarButtonTableViewCell:
      actionButtonCell.addAction(title: "Add to calendar".localized, handler: { _ in
        Importer.import(event: EventEntity(), to: .calendar,
                        completion: { result in ImportResultHandler.result(type: result, in: self)
        })
      })
      return actionButtonCell

    case .addToReminderButtonTableViewCell:
      actionButtonCell.addAction(title: "Add to reminder".localized,
                                 handler: { _ in Importer.import(event: EventEntity(), to: .calendar,
                                                                    completion: { result in
                                                                      ImportResultHandler.result(type: result, in: self)
                                 })
      })
      return actionButtonCell

    case .joinButtonTableViewCell:
      actionButtonCell.addAction(title: "Join".localized, handler: { _ in
        self.goToRegistrationPreview()
      })
      return actionButtonCell
    }
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

  func getItem(from event: EventEntity, at index: Int) -> String {
    let speeches = event.speeches
    var detailsOfSpeech = ""

    if speeches.count > 0 {
      let speech = speeches[index].title
      let name = speeches[index].user?.name  ?? ""
      let descriptionText = speeches[index].descriptionText
      detailsOfSpeech = speech + "\n" + descriptionText + "\n" + name
    }
    return detailsOfSpeech
  }
}
