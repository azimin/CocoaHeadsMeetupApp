//
//  ImagePickerViewController.swift
//  CHMeetupApp
//
//  Created by Michael Galperin on 28.02.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit
import Photos

typealias ImagePickerCompletion = (UIImage) -> Void

// MARK: - UI & Lifecycle
class ImagePickerViewController: UIViewController {

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }

  var album: PHAssetCollection? = PhotosHelper.cameraRollAlbum {
    didSet {
      if let headerExpandButton = navigationItem.titleView as? UIButton {
        headerExpandButton.setTitle(
          "\(album?.localizedTitle ?? defaultAlbumTitle) \(expandChar)",
          for: .normal
        )
      }
      fetchImages()
    }
  }

  fileprivate let phCellId = "CHPhotoCellIdentificator"
  fileprivate var completionBlock: ImagePickerCompletion?

  fileprivate var assets = [PHAsset]() // grid dataSource

  // ----- Displaying settings -----
  fileprivate let defaultAlbumTitle = "Фотоплёнка".localized
  fileprivate let expandChar = "▿"
  fileprivate let layoutInset: CGFloat = 1
  fileprivate let imagesInRaw: CGFloat = 3
  fileprivate var imageWidth: CGFloat {
    return UIScreen.main.bounds.size.width / imagesInRaw
  }
  fileprivate let bottomBarHeight: CGFloat = 44

  // --- UI ---
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = self.layoutInset
    layout.minimumInteritemSpacing = layout.minimumLineSpacing
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: self.phCellId)
    return collectionView
  }()

  lazy var bottomBar: UIToolbar = {
    let bar = UIToolbar()
    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
    bar.items = [cancelButton]
    return bar
  }()

  init(photoSelectedBlock: @escaping ImagePickerCompletion) {
    self.completionBlock = photoSelectedBlock
    super.init(nibName: nil, bundle: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // --- Images grid ---
    view.backgroundColor = .white
    view.addSubview(collectionView)
    collectionView.anchor(
      left: view.leftAnchor,
      top: view.topAnchor,
      right: view.rightAnchor,
      bottom: view.bottomAnchor,
      leftConstant: 0,
      topConstant: 0,
      rightConstant: 0,
      bottomConstant: -bottomBarHeight
    )

    // --- Bottom Bar ---
    view.addSubview(bottomBar)
    bottomBar.anchor(
      left: view.leftAnchor,
      top: nil,
      right: view.rightAnchor,
      bottom: view.bottomAnchor,
      leftConstant: 0,
      topConstant: 0,
      rightConstant: 0,
      bottomConstant: 0,
      heightConstant: bottomBarHeight
    )

    // --- Navigation Bar ---
    let headerExpandButton = UIButton(type: .system)
    headerExpandButton.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
    headerExpandButton.setTitle("\(defaultAlbumTitle) \(expandChar)", for: .normal)
    headerExpandButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
    headerExpandButton.addTarget(self, action: #selector(selectAlbumTapped), for: .touchUpInside)
    navigationItem.titleView = headerExpandButton

    fetchImages()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}

// MARK: - Functions
extension ImagePickerViewController {
  func fetchImages() {
    if let album = album {
      PhotosHelper.getAssetsFromAlbum(album: album, completion: { results in
        switch results {
          case .Assets(let assets): self.assets = assets
          case .Asset(let asset): self.assets = [asset]
          case .Error: print("Error while fetching assets from album \(album.localizedTitle)")
        }
        DispatchQueue.main.async {
          self.collectionView.reloadData()
        }
      })
    }
  }

  // ----- navigationBar -----
  func selectAlbumTapped() {
    let albumPickerController = AlbumPickerViewController()
    albumPickerController.parentPickerController = self
    albumPickerController.selectedAlbum = self.album
    let albumNavigationController = UINavigationController(rootViewController: albumPickerController)
    navigationController?.present(albumNavigationController, animated: true, completion: nil)
  }

  // ----- bottomBar -----
  func cancelTapped() {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ImagePickerViewController: UICollectionViewDelegate,
                         UICollectionViewDataSource,
                         UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return assets.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //swiftlint:disable force_cast line_length
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: phCellId, for: indexPath) as! ImageCollectionViewCell
    PhotosHelper.getImageBy(asset: assets[indexPath.row], size: imageWidth) { fetchedImage in
      cell.imageView.image = fetchedImage
    }
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    PhotosHelper.getImageBy(asset: assets[indexPath.row], mode: .highQualityFormat) { fetchedImage in
      self.completionBlock?(fetchedImage)
      DispatchQueue.main.async {
        self.dismiss(animated: true, completion: nil)
      }
    }
  }
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let imageCollectionViewCellSide = imageWidth - layoutInset
    return CGSize(
      width: imageCollectionViewCellSide,
      height: imageCollectionViewCellSide
    )
  }
}
