//
//  FetchingElementsProtocol.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 06/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation
import RealmSwift

protocol FetchingElements {
  associatedtype Value = PlainObjectType
  associatedtype Parent = Object

  static func fetchElements(request: Request<[Value]>, to parent: Parent?, completion: (() -> Void)?)
}
