//
//  ImageLoader.swift
//  CHMeetupApp
//
//  Created by Igor Voynov on 06.04.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

protocol ImageLoaderTask {
  var identifier: Int { get }
}

extension ImageLoaderTask where Self: Hashable {
  var identifier: Int {
    return hashValue
  }
}

protocol AnyImageLoader: class {

  func load(into imageView: UIImageView,
            from url: URL,
            placeholder: UIImage?,
            progressBlock: ImageLoader.ProgressBlock?,
            completionHandler: ImageLoader.CompletionBlock?)

  func cancel(_ imageView: UIImageView)

  func loadImage(from url: URL,
                 progressBlock: ImageLoader.ProgressBlock?,
                 completionHandler: ImageLoader.CompletionBlock?) -> ImageLoaderTask

  func cancel(_ task: ImageLoaderTask)

  func clearCache()

}

extension AnyImageLoader {

  func load(into imageView: UIImageView,
            from url: URL,
            placeholder: UIImage? = nil,
            progressBlock: ImageLoader.ProgressBlock? = nil,
            completionHandler: ImageLoader.CompletionBlock? = nil) {
    load(into: imageView,
         from: url,
         placeholder: placeholder,
         progressBlock: progressBlock,
         completionHandler: completionHandler)
  }

  func loadImage(from url: URL,
                 progressBlock: ImageLoader.ProgressBlock? = nil,
                 completionHandler: ImageLoader.CompletionBlock? = nil) -> ImageLoaderTask {
    return loadImage(from: url,
                     progressBlock: progressBlock,
                     completionHandler: completionHandler)
  }
}

protocol ImageLoader: AnyImageLoader {

  static var standard: Self { get }

  associatedtype Task: ImageLoaderTask, Hashable

  func specificLoad(into imageView: UIImageView,
                    from url: URL,
                    placeholder: UIImage?,
                    progressBlock: ImageLoader.ProgressBlock?,
                    completionHandler: ImageLoader.CompletionBlock?)

  func specificCancel(_ imageView: UIImageView)

  func specificLoadImage(from url: URL,
                         progressBlock: ImageLoader.ProgressBlock?,
                         completionHandler: ImageLoader.CompletionBlock?) -> Task

  func specificCancel(_ task: Task)

  func specificClearCache()
}

extension ImageLoader {

  typealias ProgressBlock = (_ receivedSize: Int, _ totalSize: Int) -> Void
  typealias CompletionBlock = (_ image: UIImage?, _ error: Error?) -> Void

  func load(into imageView: UIImageView,
            from url: URL,
            placeholder: UIImage?,
            progressBlock: ImageLoader.ProgressBlock?,
            completionHandler: ImageLoader.CompletionBlock?) {
    specificLoad(into: imageView,
                 from: url,
                 placeholder: placeholder,
                 progressBlock: progressBlock,
                 completionHandler: completionHandler)
  }

  func cancel(_ imageView: UIImageView) {
    specificCancel(imageView)
  }

  func loadImage(from url: URL,
                 progressBlock: ImageLoader.ProgressBlock?,
                 completionHandler: ImageLoader.CompletionBlock?) -> ImageLoaderTask {
    return specificLoadImage(from: url,
                             progressBlock: progressBlock,
                             completionHandler: completionHandler)
  }

  func cancel(_ task: ImageLoaderTask) {
    specificCancel(task as! Task) // swiftlint:disable:this force_cast
  }

  func clearCache() {
    specificClearCache()
  }
}
