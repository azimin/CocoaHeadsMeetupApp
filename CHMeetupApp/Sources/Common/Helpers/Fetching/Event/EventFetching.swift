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
      defer {
        DispatchQueue.main.async { completion?() }
      }

      guard let list = list, error == nil else { return }

      realmWrite {
        let creators = mainRealm.objects(CreatorEntity.self)
        mainRealm.delete(creators)
      }

      EventPlainObjectTranslation.translate(of: list, to: parent)
    })
  }
}
