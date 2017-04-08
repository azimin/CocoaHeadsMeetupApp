//
//  SpeechFetching.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 09/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

struct SpeechFetching: FetchingElements {
  static func fetchElements(request: Request<[SpeechPlainObject]>,
                            to parent: EventEntity?, completion: (() -> Void)? = nil) {
    Server.standard.request(request, completion: { list, error in
      guard let list = list,
        error == nil else { return }

      SpeechPlainObjectTranslation.translate(of: list, to: parent)
      completion?()
    })

  }
}
