//
//  EventFetching.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 06/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

struct EventFetching: FetchingElements {
  static func fetchElements(request: Request<[EventPlainObject]>,
                            to parent: EventEntity? = nil, completion: (() -> Void)? = nil) {
    Server.standard.request(request, completion: { list, error in
      guard let list = list,
        error == nil else { return }

      EventPlainObjectTranslation.translate(of: list, to: parent)
      completion?()
    })
  }
}
