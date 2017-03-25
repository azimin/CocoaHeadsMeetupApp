//
//  CellViewModel.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 09/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

// Use this type in non-generic cases
protocol CellViewAnyModelType {
  static func cellClass() -> UIView.Type
  func setup(on cell: UIView)
}

// This is for generic one and models itselfs
protocol CellViewModelType: CellViewAnyModelType {
  associatedtype CellClass: UIView
  func setup(on cell: CellClass)
}

// From generic to runtime
extension CellViewModelType {
  static func cellClass() -> UIView.Type {
    return Self.CellClass.self
  }

  func setup(on cell: UIView) {
    setup(on: cell as! Self.CellClass) // swiftlint:disable:this force_cast
  }
}
