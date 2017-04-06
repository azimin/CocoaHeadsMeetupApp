//
//  FetchingElementsProtocol.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 06/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

protocol FetchingElements {
  associatedtype Value = PlainObjectType

  static func fetchElements(request: Request<[Value]>, completion: (() -> Void)?)
}
