//
//  CHAlbumPicker.swift
//  CHMeetupApp
//
//  Created by Michael Galperin on 01.03.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit
import Photos

class CHAlbumPicker: UIViewController {

  var parentPickerController: CHImagePicker?
  var selectedAlbum: PHAssetCollection?

  fileprivate var albums = [PHAssetCollection]()
  fileprivate let albumCellID = "albumCellIDentifier"

  // --- UI ---
  lazy var tableView: UITableView = {
    let tv = UITableView()
    tv.frame = UIScreen.main.bounds
    tv.delegate = self
    tv.dataSource = self
    tv.register(CHAlbumCell.self, forCellReuseIdentifier: self.albumCellID)
    return tv
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white
    view.addSubview(tableView)

    navigationItem.title = "Альбомы"
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .cancel,
      target: self,
      action: #selector(dismissed))
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    PhotosHelper.getAlbums { fetchedAlbums in
      self.albums = fetchedAlbums
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  func dismissed() {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CHAlbumPicker: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return albums.count
  }
  var imgViewSelected: UIImageView {
    let imgView = UIImageView()
    imgView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
    imgView.tintColor = UIColor(red: 95 / 255, green: 148 / 255, blue: 238 / 255, alpha: 1)
    imgView.image = #imageLiteral(resourceName: "Checked_1900a4_25").withRenderingMode(.alwaysTemplate)
    return imgView
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //swiftlint:disable force_cast
    let cell = tableView.dequeueReusableCell(withIdentifier: albumCellID, for: indexPath) as! CHAlbumCell
    let album = albums[indexPath.row]
    cell.lblTitle.text = album.localizedTitle
    PhotosHelper.getLastPhotoFrom(album: album) { image in
      cell.albumPreview.image = image
    }
    cell.accessoryView = (album == selectedAlbum ? imgViewSelected : nil)
    return cell
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    parentPickerController?.album = albums[indexPath.row]
    dismissed()
  }
}

/// - MARK: CHAlbumCell
class CHAlbumCell: UITableViewCell {

  let albumPreview: UIImageView = {
    let iv = PhotosHelper.configuredImageView
    iv.layer.cornerRadius = 8
    iv.backgroundColor = .lightGray
    return iv
  }()

  let lblTitle: UILabel = {
    let lbl = UILabel()
    lbl.font = UIFont.systemFont(ofSize: 19)
    return lbl
  }()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)

    addSubview(albumPreview)
    addSubview(lblTitle)
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

    lblTitle.anchor(centerX: nil, centerY: centerYAnchor)
    lblTitle.anchor(
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
