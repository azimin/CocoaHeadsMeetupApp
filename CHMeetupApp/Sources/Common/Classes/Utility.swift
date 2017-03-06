//
//  Utility.swift
//  CHMeetupApp
//
//  Created by Igor Tudoran on 28.02.17.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

// MARK: - Constants:

// MARK: - Enums:

// MARK: - Structs:

// MARK: - Functions:

func viewController(_ vcID: String, storyboard name: String? = "Main") -> UIViewController {
  return UIStoryboard(name: name!, bundle: nil).instantiateViewController(withIdentifier: vcID)
}

func localized(_ string: String) -> String {
  return NSLocalizedString(string, comment: "Localized: \(string)")
}
