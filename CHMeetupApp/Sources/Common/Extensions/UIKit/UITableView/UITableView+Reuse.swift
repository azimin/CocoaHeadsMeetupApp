//
//  UITableView+Reuse.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 09/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit.UITableView

extension UITableView {
  func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
    let identifier = T.identifier
    return dequeueReusableCell(withIdentifier: identifier,
                               for: indexPath) as! T // swiftlint:disable:this force_cast
  }

  func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
    let identifier = T.identifier
    return dequeueReusableHeaderFooterView(withIdentifier: identifier) as! T // swiftlint:disable:this force_cast
  }
}
