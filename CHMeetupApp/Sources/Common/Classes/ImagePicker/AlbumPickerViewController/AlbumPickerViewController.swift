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

  fileprivate enum AlbumPickerConstants {
    static let tableViewCellID = "albumCellIDentifier"
    static let navigationItemTitle = "Альбомы".localized
    static let tableViewCellHeight: CGFloat = 100
  }

  var parentPickerController: ImagePickerViewController?
  var selectedAlbum: PHAssetCollection?

  fileprivate var albums = [PHAssetCollection]()

  // --- UI ---
  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(AlbumInfoTableViewCell.self, forCellReuseIdentifier: AlbumPickerConstants.tableViewCellID)
    return tableView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white
    view.addSubview(tableView)
    tableView.anchorToAllSides(of: view)

    navigationItem.title = AlbumPickerConstants.navigationItemTitle
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .cancel,
      target: self,
      action: #selector(close)
    )

    PhotosHelper.getAlbums { [weak self] fetchedAlbums in
      self?.albums = fetchedAlbums
      DispatchQueue.main.async {
        self?.tableView.reloadData()
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
    imageView.image = #imageLiteral(resourceName: "Checked_1900a4_75").withRenderingMode(.alwaysTemplate)
    return imageView
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //swiftlint:disable force_cast
    let cell = tableView.dequeueReusableCell(
      withIdentifier: AlbumPickerConstants.tableViewCellID,
      for: indexPath) as! AlbumInfoTableViewCell
    let album = albums[indexPath.row]
    cell.albumTitleLabel.text = album.localizedTitle
    PhotosHelper.getLastPhoto(from: album) { [weak cell] image in
      cell?.albumPreview.image = image
    }
    cell.accessoryView = (album == selectedAlbum ? imageViewSelected : nil)
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return AlbumPickerConstants.tableViewCellHeight
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    parentPickerController?.album = albums[indexPath.row]
    close()
  }

}
