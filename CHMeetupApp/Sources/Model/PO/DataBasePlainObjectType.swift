//
//  DataBasePlainObjectType.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 05/03/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation
import RealmSwift

protocol DataBasePlainObjectType {
  associatedtype DataModelType: Object

  static func mapFromObject(object: DataModelType) -> Self
  func mapToObject() -> DataModelType
}
