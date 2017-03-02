//
//  RequestContentParser.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 01/03/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation

struct RequestContentParser<T> {
  var parseLogic: (Any) -> (T?, ServerError?)
}
