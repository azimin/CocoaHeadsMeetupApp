//
//  AlbumInfoTableViewCell.swift
//  CHMeetupApp
//
//  Created by Michael Galperin on 03.03.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit
import Photos

class AlbumInfoTableViewCell: UITableViewCell {

  @IBOutlet weak var albumPreview: UIImageView! {
    didSet {
      albumPreview.layer.masksToBounds = true
      albumPreview.layer.cornerRadius = 8
    }
  }
  @IBOutlet weak var albumTitleLabel: UILabel!

  var album: PHAssetCollection! {
    didSet {
      PhotosHelper.getLastPhoto(from: album, size: albumPreview.frame.size) { [weak self] image in
        self?.albumPreview.image = image
      }
      albumTitleLabel.text = album.localizedTitle
    }
  }

}

extension AlbumInfoTableViewCell: ReusableCell {

  static var identifier: String {
    return String(describing: self)
  }

  static var nib: UINib? {
    return UINib(nibName: String(describing: self), bundle: nil)
  }

}
