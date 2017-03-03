//
//  CHImagePicker.swift
//  CHMeetupApp
//
//  Created by Michael Galperin on 28.02.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit
import Photos

typealias CHImageCompletion = (UIImage) -> Void

/// Presents ImagePicker and returns selected image in callback
///
/// - parameter controller: `UIViewController` for picker to be presented on
/// - parameter photoSelectedBlock: callback with `UIImage`
func presentCHImagePicker(
  on controller: UIViewController,
  photoSelectedBlock: @escaping CHImageCompletion) {
  controller.requireAccess(to: .photosLibrary) { granted in
    if granted {
      let vc = CHImagePicker(photoSelectedBlock: photoSelectedBlock)
      let nav = UINavigationController(rootViewController: vc)
      DispatchQueue.main.async {
        controller.present(nav, animated: true, completion: nil)
      }
    }
  }
}

// MARK: - UI & Lifecycle
fileprivate let phCellId = "CHPhotoCellIdentificator"
/// Use it via **presentCHImagePicker** func
class CHImagePicker: UIViewController {

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }

  var album: PHAssetCollection? = PhotosHelper.cameraRollAlbum {
    didSet {
      if let btn = navigationItem.titleView as? UIButton {
        btn.setTitle(
          "\(album?.localizedTitle ?? defaultAlbumTitle) \(expandChar)",
          for: .normal
        )
      }
      fetchImages()
    }
  }

  fileprivate var completionBlock: CHImageCompletion?

  fileprivate var assets = [PHAsset]() // grid dataSource

  // ----- Displaying settings -----
  fileprivate let defaultAlbumTitle = "Фотоплёнка"
  fileprivate let expandChar = "▾"
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
    let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    cv.backgroundColor = .white
    cv.delegate = self
    cv.dataSource = self
    cv.register(CHImageCell.self, forCellWithReuseIdentifier: phCellId)
    return cv
  }()

  lazy var bottomBar: UIToolbar = {
    let bar = UIToolbar()
    let btnCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
    bar.items = [btnCancel]
    return bar
  }()

  init(photoSelectedBlock: @escaping CHImageCompletion) {
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
    let btnTop = UIButton(type: .system)
    btnTop.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
    btnTop.setTitle("\(defaultAlbumTitle) \(expandChar)", for: .normal)
    btnTop.titleLabel?.font = UIFont.systemFont(ofSize: 17)
    btnTop.addTarget(self, action: #selector(selectAlbumTapped), for: .touchUpInside)
    navigationItem.titleView = btnTop

    fetchImages()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}

// MARK: - Functions
extension CHImagePicker {
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
    let vc = CHAlbumPicker()
    vc.parentPickerController = self
    vc.selectedAlbum = self.album
    let nav = UINavigationController(rootViewController: vc)
    navigationController?.present(nav, animated: true, completion: nil)
  }

  // ----- bottomBar -----
  func cancelTapped() {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension CHImagePicker: UICollectionViewDelegate,
                         UICollectionViewDataSource,
                         UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return assets.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //swiftlint:disable force_cast
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: phCellId, for: indexPath) as! CHImageCell
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
    let side = imageWidth - layoutInset
    return CGSize(width: side, height: side)
  }
}

// MARK: - CHImageCell
fileprivate class CHImageCell: UICollectionViewCell {

  let imageView = PhotosHelper.configuredImageView

  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(imageView)
    imageView.anchorToAllSides(of: self)
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
