//
//  KingfisherImageLoader.swift
//  CHMeetupApp
//
//  Created by Igor Voynov on 06.04.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit
import Kingfisher

extension RetrieveImageTask: ImageLoaderTask, Hashable {
  public var hashValue: Int {
    return downloadTask.debugDescription.hashValue
  }
  public static func == (lhs: RetrieveImageTask, rhs: RetrieveImageTask) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}

final class KingfisherImageLoader: ImageLoader {

  static var standard: KingfisherImageLoader {
    return KingfisherImageLoader()
  }

  func specificLoad(into imageView: UIImageView,
                    from url: URL,
                    placeholder: UIImage? = nil,
                    progressBlock: ImageLoader.ProgressBlock? = nil,
                    completionHandler: ImageLoader.CompletionBlock? = nil) {

    imageView.kf.cancelDownloadTask()
    imageView.kf.setImage(with: url, placeholder: placeholder, options: [],
                          progressBlock: { (receivedSize, totalSize) in
      if let progressBlock = progressBlock {
        progressBlock(Int(truncatingIfNeeded: receivedSize), Int(truncatingIfNeeded: totalSize))
      }
    }, completionHandler: { (image, error, _, _) in
      if let completionHandler = completionHandler {
        if let image = image, error == nil {
          completionHandler(image, nil)
        } else {
          completionHandler(nil, error)
        }
      }
    })
  }

  func specificCancel(_ imageView: UIImageView) {
    imageView.kf.cancelDownloadTask()
  }

  func specificLoadImage(from url: URL,
                         progressBlock: ImageLoader.ProgressBlock? = nil,
                         completionHandler: ImageLoader.CompletionBlock? = nil) -> RetrieveImageTask {

    return KingfisherManager.shared.retrieveImage(with: url, options: [], progressBlock: { (receivedSize, totalSize) in
      if let progressBlock = progressBlock {
        progressBlock(Int(truncatingIfNeeded: receivedSize), Int(truncatingIfNeeded: totalSize))
      }
    }, completionHandler: { (image, error, _, _) in
      if let completionHandler = completionHandler {
        if let image = image, error == nil {
          completionHandler(image, nil)
        } else {
          completionHandler(nil, error)
        }
      }
    })
  }

  func specificCancel(_ task: RetrieveImageTask) {
    task.cancel()
  }

  func specificClearCache() {
    KingfisherManager.shared.cache.clearMemoryCache()
    KingfisherManager.shared.cache.clearDiskCache()
  }
}
