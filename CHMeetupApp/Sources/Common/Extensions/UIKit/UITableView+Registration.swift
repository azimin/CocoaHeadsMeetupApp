//
//  UITableView+Registration.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 09/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit.UITableView

extension UITableView {
  func registerNibs(from displayCollection: DisplayCollection) {
    registerNibs(fromType: type(of: displayCollection))
  }

  func registerNibs(fromType displayCollectionType: DisplayCollection.Type) {
    for cellModel in displayCollectionType.modelsForRegistration {
      if let tableCellClass = cellModel.cellClass() as? UITableViewCell.Type {
        registerNib(for: tableCellClass)
      }
    }
  }

  func registerNib(for cellClass: UITableViewCell.Type) {
    register(cellClass.nib, forCellReuseIdentifier: cellClass.identifier)
  }

  func registerHeaderNib(for headerClass: UITableViewHeaderFooterView.Type) {
    register(headerClass.nib, forHeaderFooterViewReuseIdentifier: headerClass.identifier)
  }

  func registerClass(for cellClass: UITableViewCell.Type) {
    register(cellClass, forCellReuseIdentifier: cellClass.identifier)
  }
}
