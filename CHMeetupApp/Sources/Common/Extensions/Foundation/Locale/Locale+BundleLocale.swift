//
//  Locale+BundleLocale.swift
//  CHMeetupApp
//
//  Created by Sam Mejlumyan on 18/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

extension Locale {
    static var bundle: Locale {
        let language = Bundle.main.preferredLocalizations[0]
        let locale = Locale(identifier: language)
        return locale
    }
}
