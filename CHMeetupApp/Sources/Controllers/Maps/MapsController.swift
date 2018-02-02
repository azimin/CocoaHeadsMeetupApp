//
//  MapsController.swift
//  MapsPlayground
//
//  Created by Alexander Zimin on 23/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit
import CoreLocation

struct MapsController {
  static var availableMaps: [MapAppType] {
    return MapAppType.allMaps.filter({ map in
      UIApplication.shared.canOpenURL(map.scheme)
    })
  }

  static func open(map: MapAppType, coordinate: CLLocationCoordinate2D) {
    let schemeURL = map.scheme(with: coordinate)

    if #available(iOS 10.0, *) {
      UIApplication.shared.open(schemeURL, options: [:], completionHandler: nil)
    } else {
      UIApplication.shared.openURL(schemeURL)
    }

  }
}
