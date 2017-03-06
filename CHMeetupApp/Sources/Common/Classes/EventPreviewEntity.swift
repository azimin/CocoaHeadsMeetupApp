//
//  EventPreviewEntity.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 05/03/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation

class EventPreviewEntity {

  func eventPreviewEntityCollection(get from: EventEntity) -> EventPreviewPO {
    var title: String = ""
    var desc: String = ""
    if from.speeches.count != 0 {
      title = from.speeches[0].title
      desc = from.speeches[0].descriptionText
    }

    let speechDetails = title + "\n" + desc
    return EventPreviewPO(speechDetails: speechDetails)
  }
}
