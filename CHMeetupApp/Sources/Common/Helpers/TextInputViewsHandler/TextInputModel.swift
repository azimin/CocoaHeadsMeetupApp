//
//  TextInputModel.swift
//  CHMeetupApp
//
//  Created by Denis on 06.04.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

protocol TextInputModel {
  associatedtype Identifier: Hashable
  var identifier: Identifier { get }
  weak var handler: TextInputViewsHandler<Identifier>? { get }
}
