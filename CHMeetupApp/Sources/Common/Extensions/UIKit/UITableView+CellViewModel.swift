//
//  UITableView+CellViewModel.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 09/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit.UITableView

extension UITableView {
  func dequeueReusableCell(for indexPath: IndexPath, with model: CellViewAnyModelType) -> UITableViewCell {

    let cellIdentifier = String(describing: type(of: model).cellClass())
    let cell = dequeueReusableCell(withIdentifier: cellIdentifier,
                                   for: indexPath)

    model.setup(on: cell)

    return cell
  }
}
