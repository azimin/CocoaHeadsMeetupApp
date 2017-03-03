//
//  AlbumPickerViewController.swift
//  CHMeetupApp
//
//  Created by Michael Galperin on 01.03.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit
import Photos

class AlbumPickerViewController: UIViewController {

  var parentPickerController: ImagePickerViewController?
  var selectedAlbum: PHAssetCollection?

  fileprivate var albums = [PHAssetCollection]()
  fileprivate let albumCellID = "albumCellIDentifier"

  // --- UI ---
  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.frame = UIScreen.main.bounds
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(AlbumInfoTableViewCell.self, forCellReuseIdentifier: self.albumCellID)
    return tableView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white
    view.addSubview(tableView)

    navigationItem.title = "Альбомы".localized
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .cancel,
      target: self,
      action: #selector(close)
    )
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

  func close() {
    dismiss(animated: true, completion: nil)
  }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AlbumPickerViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return albums.count
  }

  var imageViewSelected: UIImageView {
    let imageView = UIImageView()
    imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
    imageView.tintColor = UIColor(red: 95 / 255, green: 148 / 255, blue: 238 / 255, alpha: 1)
    imageView.image = #imageLiteral(resourceName: "Checked_1900a4_25").withRenderingMode(.alwaysTemplate)
    return imageView
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //swiftlint:disable force_cast
    let cell = tableView.dequeueReusableCell(withIdentifier: albumCellID, for: indexPath) as! AlbumInfoTableViewCell
    let album = albums[indexPath.row]
    cell.albumTitleLabel.text = album.localizedTitle
    PhotosHelper.getLastPhotoFrom(album: album) { image in
      cell.albumPreview.image = image
    }
    cell.accessoryView = (album == selectedAlbum ? imageViewSelected : nil)
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    parentPickerController?.album = albums[indexPath.row]
    close()
  }

}
