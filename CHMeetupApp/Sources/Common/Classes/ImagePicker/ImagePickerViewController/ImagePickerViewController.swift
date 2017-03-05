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

  enum ImagePickerConstants {
    static let collectionViewCellID = "CHPhotoCellIdentificator"
    static let defaultAlbumTitle = "Фотоплёнка".localized
    static let expandCharacter = "▿"
    static var navigationItemDefaultTitle: String {
      return "\(ImagePickerConstants.defaultAlbumTitle) \(ImagePickerConstants.expandCharacter)"
    }
    static let collectionViewLayoutInset: CGFloat = 1
    static let imagesCountInRow: CGFloat = 3
    static var imageWidth: CGFloat {
      return mainScreenSize.width / ImagePickerConstants.imagesCountInRow
    }
    static let bottomBarHeight: CGFloat = 44
    static let imageCollectionViewCellSide =
      ImagePickerConstants.imageWidth - ImagePickerConstants.collectionViewLayoutInset
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }

  var album: PHAssetCollection? = PhotosHelper.cameraRollAlbum {
    didSet {
      if let headerExpandButton = navigationItem.titleView as? UIButton {
        let firstPart = album?.localizedTitle ?? ImagePickerConstants.defaultAlbumTitle
        let buttonTitle = "\(firstPart) \(ImagePickerConstants.expandCharacter)"
        headerExpandButton.setTitle(buttonTitle, for: .normal)
      }
      fetchImages()
    }
  }

  fileprivate var completionBlock: ImagePickerCompletion?
  fileprivate var assets = [PHAsset]()

  // --- UI ---
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = ImagePickerConstants.collectionViewLayoutInset
    layout.minimumInteritemSpacing = layout.minimumLineSpacing
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(
      ImageCollectionViewCell.self,
      forCellWithReuseIdentifier: ImagePickerConstants.collectionViewCellID
    )
    return collectionView
  }()

  lazy var bottomBar: UIToolbar = {
    let bottomBar = UIToolbar()
    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
    bottomBar.items = [cancelButton]
    return bottomBar
  }()

  init(photoSelectedBlock: @escaping ImagePickerCompletion) {
    self.completionBlock = photoSelectedBlock
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
      bottomConstant: -ImagePickerConstants.bottomBarHeight
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
      heightConstant: ImagePickerConstants.bottomBarHeight
    )

    // --- Navigation Bar ---
    let headerExpandButton = UIButton(type: .system)
    headerExpandButton.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
    headerExpandButton.setTitle(ImagePickerConstants.navigationItemDefaultTitle, for: .normal)
    headerExpandButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
    headerExpandButton.addTarget(self, action: #selector(selectAlbumTapped), for: .touchUpInside)
    navigationItem.titleView = headerExpandButton

    fetchImages()
  }

}

// MARK: - Functions
extension ImagePickerViewController {

  func fetchImages() {
    if let album = album {
      PhotosHelper.getAssets(from: album, completion: { results in
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
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ImagePickerConstants.collectionViewCellID,
      for: indexPath) as! ImageCollectionViewCell
    PhotosHelper.getImage(
      by: assets[indexPath.row],
      size: ImagePickerConstants.imageWidth) { fetchedImage in
      cell.imageView.image = fetchedImage
    }
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    PhotosHelper.getImage(by: assets[indexPath.row], mode: .highQualityFormat) { fetchedImage in
      self.completionBlock?(fetchedImage)
      DispatchQueue.main.async {
        self.dismiss(animated: true, completion: nil)
      }
    }
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(
      width: ImagePickerConstants.imageCollectionViewCellSide,
      height: ImagePickerConstants.imageCollectionViewCellSide
    )
  }

}
