//
//  PastEventsDisplayCollection.swift
//  CHMeetupApp
//
//  Created by Denis on 03.03.17.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

struct PastEventsDisplayCollection {
  fileprivate(set) var sections = [Section]()
}

extension PastEventsDisplayCollection {
  //шFIXME: Need to rewrite this method after adding realm
  mutating func add(_ events: [EventPO]?) {
    guard let events = events else {
      return
    }

    for event in events {
      let sectionTitle = DateFormatter.localizedString(from: event.startTime, dateStyle: .short, timeStyle: .none)
      let section = Section(title: sectionTitle, items: [Item(event)])
      sections.append(section)
    }
  }
}

extension PastEventsDisplayCollection {
  struct Item {
    var title: String
    var dateTitle: String

    init(_ event: EventPO) {
      self.title = event.title
      let startTime = DateFormatter.localizedString(from: event.startTime, dateStyle: .none, timeStyle: .short)
      let endTime = DateFormatter.localizedString(from: event.endTime, dateStyle: .none, timeStyle: .short)

      self.dateTitle = "Начало: " + startTime + "\n" + "Конец: " + endTime
    }
  }

  struct Section {
    var title: String
    var items: [Item]
  }
}
