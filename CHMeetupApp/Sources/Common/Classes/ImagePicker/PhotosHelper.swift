//
// PhotosHelper.swift
// https://github.com/DroidsOnRoids/PhotosHelper/blob/master/PhotosHelper.swift
//

import Photos

let mainScreenSize = UIScreen.main.bounds.size

/**
 Enum containing results of `getAssets(...)`, `getImages(...)` etc. calls. 
 Depending on options can contain an array of assets or a single asset. 
 Contains an empty error if something goes wrong.
 
 - Assets: Contains an array of assets. Will be called only once.
 - Asset:  Contains a single asset. If options.synchronous is set to `false` can be called multiple times by the system.
 - Error:  Error fetching images.
 */
enum AssetFetchResult<T> {
    case Assets([T])
    case Asset(T)
    case Error
}

/**
 *  A set of methods to create albums, save and retrieve images using the Photos Framework.
 */
final class PhotosHelper {

    /**
     *  Define order, amount of assets and - if set - a target size. 
   When count is set to zero all assets will be fetched. 
   When size is not set original assets will be fetched.
     */
    struct FetchOptions {
        var count: Int
        var newestFirst: Bool
        var size: CGSize?

        init() {
          self.count = 0
          self.newestFirst = true
          self.size = nil
        }
    }

  static var cameraRollAlbum: PHAssetCollection? {
    let ops = PHFetchOptions()
    ops.fetchLimit = 1
    return PHAssetCollection.fetchAssetCollections(
      with: .smartAlbum,
      subtype: .smartAlbumUserLibrary,
      options: ops
    ).firstObject
  }

  static var configuredImageView: UIImageView {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    return imageView
  }

  private static func correct(_ size: CGSize) -> CGSize {
    var result = size
    let scale = UIScreen.main.scale
    result.width *= scale
    result.height *= scale
    return result
  }

  static func getLastPhoto(
    from album: PHAssetCollection,
    size: CGSize,
    completion: @escaping ImagePickerCompletion) {
    let ops = PHFetchOptions()
    ops.fetchLimit = 1
    ops.sortDescriptors = [
      NSSortDescriptor(key: "creationDate", ascending: false)
    ]

    if let first = PHAsset.fetchAssets(in: album, options: ops).firstObject {
      let reqOps = PHImageRequestOptions()
      reqOps.isSynchronous = true
      reqOps.deliveryMode = .highQualityFormat
      PHImageManager.default().requestImage(
        for: first,
        targetSize: correct(size),
        contentMode: .aspectFill,
        options: reqOps
      ) { image, _ in
          if let image = image {
            completion(image)
          }
      }
    }
  }

  static func getImage(
    by asset: PHAsset,
    size: CGSize? = nil,
    mode: PHImageRequestOptionsDeliveryMode = .opportunistic,
    fetchRequestID: @escaping (PHImageRequestID) -> Void,
    completion: @escaping ImagePickerCompletion) {

    let requestOptions = PHImageRequestOptions()
    requestOptions.deliveryMode = mode
    requestOptions.resizeMode = mode == .highQualityFormat ? .exact : .fast
    requestOptions.isNetworkAccessAllowed = false

    let targetSize = correct(size ?? mainScreenSize)

    fetchRequestID(
      PHImageManager.default().requestImage(
        for: asset,
        targetSize: targetSize,
        contentMode: .aspectFill,
        options: requestOptions
      ) { image, info in
        //swiftlint:disable line_length
        let isCancelled = (info?[PHImageCancelledKey] as? NSNumber)?.boolValue ?? false
        if !isCancelled, let image = image {
          completion(image)
        }
      }
    )
  }

  //swiftlint:disable void_return
    /**
     Try to retrieve assets from a Photos album.
     
     - parameter options:      Define how the assets will be fetched.
     - parameter fetchOptions: Define order and amount of assets. Size is ignored.
     - parameter completion:   Called in the background when assets were retrieved or in case of any error.
     */
  static func getAssets(
    from album: PHAssetCollection,
    fetchOptions: FetchOptions = FetchOptions(),
    completion: @escaping (_ result: AssetFetchResult<PHAsset>) -> ()) {

        var assets = [PHAsset]()
        let fetchedAssets = PHAsset.fetchAssets(in: album, options: nil)
        let range = NSRange(location: 0, length: fetchedAssets.count)
        let indexes = NSIndexSet(indexesIn: range) as IndexSet
        fetchedAssets.enumerateObjects(at: indexes, options: []) { asset, _, _ in
          assets.append(asset)
        }

        completion(.Assets(assets.reversed()))
  }

    /**
     Retrieve all albums from the Photos app.
     */
  private typealias PhPair = (type: PHAssetCollectionType, subtype: PHAssetCollectionSubtype)
  static func getAlbums(completion: @escaping (_ albums: [PHAssetCollection]) -> ()) {
    let fetOps = PHFetchOptions()
    fetOps.sortDescriptors = [
      NSSortDescriptor(key: "endDate", ascending: true)
    ]
    let assetsFetOps = PHFetchOptions()
    assetsFetOps.fetchLimit = 1

    var result = [PHAssetCollection]()
      [
        PhPair(.smartAlbum, .smartAlbumUserLibrary),
        PhPair(.smartAlbum, .smartAlbumScreenshots),
        PhPair(.album, .albumRegular),
        PhPair(.smartAlbum, .smartAlbumFavorites),
        PhPair(.smartAlbum, .smartAlbumSelfPortraits)
        // possibly something can be added here
      ].map {
        return PHAssetCollection.fetchAssetCollections(
          with: $0.type,
          subtype: $0.subtype,
          options: fetOps
        )
      }.forEach {
        for i in 0..<($0.count) {
          let obj = $0[i]
          if PHAsset.fetchAssets(in: obj, options: assetsFetOps).count > 0 {
            result.append(obj)
          }
        }
      }
      completion(result)
    }
}
