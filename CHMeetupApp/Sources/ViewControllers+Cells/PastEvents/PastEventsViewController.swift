//
//  PastEventsViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 22/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class PastEventsViewController: UIViewController {
  @IBOutlet fileprivate var tableView: UITableView! {
    didSet {
      tableView.register(PastEventsTableViewCell.nib, forCellReuseIdentifier: PastEventsTableViewCell.identifier)
      tableView.estimatedRowHeight = 100
      tableView.rowHeight = UITableViewAutomaticDimension
    }
  }
  fileprivate var dataCollection = PastEventsDisplayCollection()

  override func viewDidLoad() {
    super.viewDidLoad()
    fetchEvents()
  }

  override func customTabBarItemContentView() -> CustomTabBarItemView {
    return TabBarItemView.create(with: .past)
  }
}

extension PastEventsViewController: UITableViewDataSource, UITableViewDelegate {

  func numberOfSections(in tableView: UITableView) -> Int {
    return dataCollection.sections.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let section = dataCollection.sections[section]
    return section.items.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let identifier = PastEventsTableViewCell.identifier
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! PastEventsTableViewCell
    // swiftlint:disable:previous force_cast
    let item = dataCollection.sections[indexPath.section].items[indexPath.row]
    cell.configure(with: item)

    return cell
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let section = dataCollection.sections[section]
    return section.title
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    showEvent(at: indexPath)
  }
}

fileprivate extension PastEventsViewController {

  func fetchEvents() {
    //FIXME: Replace with real data
    var demoEvents = [EventPO]()
    let numberOfDemoEvents = 10
    for eventIndex in 0...numberOfDemoEvents {
      //Create past event
      let oneDayTimeInterval = 3600 * 24
      let eventTime = Date().addingTimeInterval(-TimeInterval(oneDayTimeInterval * eventIndex))
      let eventDuration: TimeInterval = 3600 * 4

      var event = EventPO()
      event.startTime = eventTime
      event.endTime = eventTime.addingTimeInterval(eventDuration)
      event.title += " \(numberOfDemoEvents - eventIndex)"
      demoEvents.append(event)
    }
    dataCollection.add(demoEvents)
    tableView.reloadData()
  }

  func showEvent(at indexPath: IndexPath) {
    navigationController?.pushViewController(ViewControllersFactory.eventPreviewViewController, animated: true)
  }
}
