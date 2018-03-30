//
//  UICollectionView+CellViewModel.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 09/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit.UICollectionView

extension UICollectionView {
  func dequeueReusableCell(for indexPath: IndexPath, with model: CellViewAnyModelType) -> UICollectionViewCell {

    let cellIdentifier = String(describing: type(of: model).cellClass())
    let cell = dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                   for: indexPath)

    model.setupDefault(on: cell)

    return cell
  }
}
