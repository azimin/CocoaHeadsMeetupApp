//
//  GiveSpeechFetching.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 16/08/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

struct GiveSpeechFetching: FetchingElements {
  static func fetchElements(request: Request<[GiveSpeechPlainObject]>,
                            to parent: GiveSpeechEntity? = nil,
                            completion: (() -> Void)? = nil) {
    Server.standard.request(request, completion: { list, error in
      defer {
        DispatchQueue.main.async { completion?() }
      }

      guard let list = list,
        error == nil else { return }
      GiveSpeechPlainObjectTranslation.translate(of: list, to: parent)
    })
  }
}
