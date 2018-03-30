//
//  TemplateEntity.swift
//  CHMeetupApp
//
//  Created by Dmitriy Lis on 23/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation
import RealmSwift

protocol TemplateEntity {
  var isTemplate: Bool { get set }
  static var templateEntity: Self { get }
}
