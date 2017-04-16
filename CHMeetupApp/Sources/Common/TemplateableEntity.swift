//
//  TemplateableEntity.swift
//  CHMeetupApp
//
//  Created by Dmitriy Lis on 11/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import RealmSwift

protocol TemplateableEntity {
  associatedtype EntityType: Object
  static var templateEntity: EntityType { get }
}
