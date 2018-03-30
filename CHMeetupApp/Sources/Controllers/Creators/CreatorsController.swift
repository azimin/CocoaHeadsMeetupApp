//
//  CreatorsFetching.swift
//  CHMeetupApp
//
//  Created by Dmitriy Lis on 29/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

struct CreatorsController: FetchingElements {
  static func fetchElements(request: Request<[CreatorPlainObject]>,
                            to parent: CreatorEntity? = nil,
                            completion: (() -> Void)? = nil) {
    Server.standard.request(request, completion: { list, error in
      defer {
        DispatchQueue.main.async { completion?() }
      }

      guard let list = list,
        error == nil else { return }
      CreatorPlainObjectTranslation.translate(of: list, to: nil)
    })
  }
}
