//
//  EventPreviewViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 23/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

struct InfoAboutEvent {
  let title = "Очередная встреча CocoaHeads"
  let namesOfLecture = ["Андрей Юткин", "Вадим Дробинин", "Никита Кортунов"]
  let speechThemes = ["Media Picker - to infinity and beyond",
                      "Защищаем себя и пользователей:: руководство по безопасности",
                      "Как ускорить разработку приложений и есть ли жизнь после Parse"]

}

enum TypeOfCells {
  case title
  case addressAndAdd
  case lectureInfo
  case join
}

class EventPreviewViewController: UIViewController {

  @IBOutlet var eventPreviewTableView: UITableView! {
    didSet {
      eventPreviewTableView.register(JoinButtonCell.nib, forCellReuseIdentifier: JoinButtonCell.identifier)
      eventPreviewTableView.register(AddressAndAddButtonsCell.nib,
                                     forCellReuseIdentifier: AddressAndAddButtonsCell.identifier)
      eventPreviewTableView.register(TitleEventCell.nib, forCellReuseIdentifier: TitleEventCell.identifier)
      eventPreviewTableView.register(InfoAboutLectureCell.nib, forCellReuseIdentifier: InfoAboutLectureCell.identifier)

      eventPreviewTableView.estimatedRowHeight = 44
      eventPreviewTableView.rowHeight = UITableViewAutomaticDimension
    }
  }

  let groupType: [TypeOfCells] = [.title, .addressAndAdd, .lectureInfo, .lectureInfo, .lectureInfo, .join]

  override func viewDidLoad() {
    super.viewDidLoad()
    eventPreviewTableView.separatorColor = UIColor.clear
  }
}

extension EventPreviewViewController: UITableViewDataSource, UITableViewDelegate {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return groupType.count
  }

  // swiftlint:disable colon:next force_cast
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch groupType[indexPath.row] {
    case .title:
      let cell = tableView.dequeueReusableCell(withIdentifier: TitleEventCell.identifier,
                                               for: indexPath) as! TitleEventCell
      cell.configure(with: InfoAboutEvent())
      return cell
    case .addressAndAdd:
      let cell = tableView.dequeueReusableCell(withIdentifier: AddressAndAddButtonsCell.identifier,
                                           for: indexPath) as! AddressAndAddButtonsCell
      cell.controller = self
      return cell
    case .lectureInfo:
      let cell = tableView.dequeueReusableCell(withIdentifier: InfoAboutLectureCell.identifier,
                                               for: indexPath) as! InfoAboutLectureCell
      cell.configure(with: InfoAboutEvent(), index: indexPath.row)
      return cell
    case .join:
      let cell = tableView.dequeueReusableCell(withIdentifier: JoinButtonCell.identifier,
                                           for: indexPath) as! JoinButtonCell
      cell.navigationViewController = navigationController!
      return cell
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row > 1 {
      let storyboard = UIStoryboard(name: "EventPreview", bundle: nil)
      let speechViewController = storyboard.instantiateViewController(withIdentifier: "SpeechViewController")
      navigationController?.pushViewController(speechViewController, animated: true)
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
