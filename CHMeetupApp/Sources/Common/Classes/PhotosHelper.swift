//
// PhotosHelper.swift
// https://github.com/DroidsOnRoids/PhotosHelper/blob/master/PhotosHelper.swift
//

import Photos

let screenSize = UIScreen.main.bounds.size

/**
 Enum containing results of `getAssets(...)`, `getImages(...)` etc. calls. 
 Depending on options can contain an array of assets or a single asset. 
 Contains an empty error if something goes wrong.
 
 - Assets: Contains an array of assets. Will be called only once.
 - Asset:  Contains a single asset. If options.synchronous is set to `false` can be called multiple times by the system.
 - Error:  Error fetching images.
 */
public enum AssetFetchResult<T> {
    case Assets([T])
    case Asset(T)
    case Error
}

/**
 *  A set of methods to create albums, save and retrieve images using the Photos Framework.
 */
public struct PhotosHelper {

    /**
     *  Define order, amount of assets and - if set - a target size. 
   When count is set to zero all assets will be fetched. 
   When size is not set original assets will be fetched.
     */
    public struct FetchOptions {
        public var count: Int
        public var newestFirst: Bool
        public var size: CGSize?

        public init() {
            self.count = 0
            self.newestFirst = true
            self.size = nil
        }
    }

  public static var cameraRollAlbum: PHAssetCollection? {
    let ops = PHFetchOptions()
    ops.fetchLimit = 1
    return PHAssetCollection.fetchAssetCollections(
      with: .smartAlbum,
      subtype: .smartAlbumUserLibrary,
      options: ops
    ).firstObject
  }
  public static var configuredImageView: UIImageView {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    return imageView
  }

  static func getLastPhotoFrom(album: PHAssetCollection,
                               completion: @escaping CHImageCompletion) {
    let ops = PHFetchOptions()
    ops.fetchLimit = 1
    ops.sortDescriptors = [
      NSSortDescriptor(key: "creationDate", ascending: false)
    ]
    if let first = PHAsset.fetchAssets(in: album, options: ops).firstObject {
      let reqOps = PHImageRequestOptions()
      reqOps.deliveryMode = .highQualityFormat
      PHImageManager.default().requestImage(
        for: first,
        targetSize: screenSize,
        contentMode: .default,
        options: reqOps
      ) { image, _ in
          if let image = image {
            completion(image)
          }
      }
    }
  }

  static func getImageBy(
    asset: PHAsset,
    size: CGFloat? = nil,
    mode: PHImageRequestOptionsDeliveryMode = .opportunistic,
    completion: @escaping CHImageCompletion) {
      let reqOps = PHImageRequestOptions()
      reqOps.deliveryMode = mode
      let targetSize = (size != nil ? CGSize(width: size!, height: size!) : screenSize)
      PHImageManager.default().requestImage(
        for: asset,
        targetSize: targetSize,
        contentMode: .aspectFit,
        options: reqOps
      ) { image, _ in
          if let image = image {
            completion(image)
          }
    }
  }

  //swiftlint:disable void_return
    /**
     Try to retrieve assets from a Photos album.
     
     - parameter options:      Define how the assets will be fetched.
     - parameter fetchOptions: Define order and amount of assets. Size is ignored.
     - parameter completion:   Called in the background when assets were retrieved or in case of any error.
     */
  public static func getAssetsFromAlbum(
    album: PHAssetCollection,
    fetchOptions: FetchOptions = FetchOptions(),
    completion: @escaping (_ result: AssetFetchResult<PHAsset>) -> ()) {
      DispatchQueue.global().async {
        let assetsFetchOptions = PHFetchOptions()
        assetsFetchOptions.sortDescriptors =
          [
            NSSortDescriptor(key: "creationDate", ascending: !fetchOptions.newestFirst)
          ]

        var assets = [PHAsset]()

        let fetchedAssets = PHAsset.fetchAssets(in: album, options: assetsFetchOptions)

        let rangeLength = min(fetchedAssets.count, fetchOptions.count)
        let range = NSRange(location: 0, length: fetchOptions.count != 0 ? rangeLength : fetchedAssets.count)
        let indexes = NSIndexSet(indexesIn: range) as IndexSet
        fetchedAssets.enumerateObjects(at: indexes, options: []) { asset, _, _ in
          assets.append(asset)
        }

        completion(.Assets(assets))
      }
  }

    /**
     Retrieve all albums from the Photos app.
     */
  private typealias PhPair = (type: PHAssetCollectionType, subtype: PHAssetCollectionSubtype)
  public static func getAlbums(completion: @escaping (_ albums: [PHAssetCollection]) -> ()) {
    DispatchQueue.main.async {
      let fetOps = PHFetchOptions()
      fetOps.sortDescriptors = [
        NSSortDescriptor(key: "endDate", ascending: true)
      ]
      let assetsFetOps = PHFetchOptions()
      assetsFetOps.fetchLimit = 1

      var result = [PHAssetCollection]()
      [
        PhPair(.smartAlbum, .smartAlbumFavorites),
        PhPair(.smartAlbum, .smartAlbumUserLibrary),
        PhPair(.smartAlbum, .smartAlbumScreenshots),
        PhPair(.album, .albumRegular) // possibly something can be added here
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
          if i == $0.count - 1 {
            completion(
              result.sorted(by: {
                $0.localizedTitle ?? "" > $1.localizedTitle ?? ""
              })
            )
          }
        }
      }
    }
  }
}
