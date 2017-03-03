//
//  AlbumInfoTableViewCell.swift
//  CHMeetupApp
//
//  Created by Michael Galperin on 03.03.17.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class AlbumInfoTableViewCell: UITableViewCell {

  let albumPreview: UIImageView = {
    let imageView = PhotosHelper.configuredImageView
    imageView.layer.cornerRadius = 8
    imageView.backgroundColor = .lightGray
    return imageView
  }()

  let albumTitleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 19)
    return label
  }()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)

    addSubview(albumPreview)
    albumPreview.anchor(
      left: leftAnchor,
      top: topAnchor,
      right: nil,
      bottom: bottomAnchor,
      leftConstant: 8,
      topConstant: 8,
      rightConstant: 0,
      bottomConstant: -8,
      heightConstant: 0,
      widthConstant: 80
    )

    addSubview(albumTitleLabel)
    albumTitleLabel.anchor(centerX: nil, centerY: centerYAnchor)
    albumTitleLabel.anchor(
      left: albumPreview.rightAnchor,
      top: nil,
      right: rightAnchor,
      bottom: nil,
      leftConstant: 8,
      topConstant: 0,
      rightConstant: 8
    )
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
