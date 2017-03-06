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
  mutating func add(_ events: [EventEntity]?) {
    guard let events = events else {
      return
    }

    for event in events {
//      let sectionTitle = DateFormatter.localizedString(from: event.date, dateStyle: .short, timeStyle: .none)
      let section = Section(title: event.title, items: [Item(event)])
      sections.append(section)
    }
  }
}

extension PastEventsDisplayCollection {
  struct Item {
    var title: String
    var dateTitle: String

    init(_ event: EventEntity) {
      self.title = event.title
      let startTime = DateFormatter.localizedString(from: Date(timeIntervalSince1970: 1488384000),
                                                           dateStyle: .none,
                                                           timeStyle: .short)
      let endTime = DateFormatter.localizedString(from: Date(timeIntervalSince1970: 1488398400),
                                                  dateStyle: .none,
                                                  timeStyle: .short)

      self.dateTitle = "Начало: ".localized + startTime + "\n" + "Конец: ".localized + endTime
    }
  }

  struct Section {
    var title: String
    var items: [Item]
  }
}
