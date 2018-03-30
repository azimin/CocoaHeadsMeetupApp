//
//  ImageLoaderCell.swift
//  CHMeetupApp
//
//  Created by Igor Voynov on 14.04.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class GroupImageLoader {

  let loader: AnyImageLoader

  init(loader: AnyImageLoader) {
    self.loader = loader
  }

  static var standard: GroupImageLoader {
    return GroupImageLoader(loader: KingfisherImageLoader.standard)
  }

  class Task {
    let url: URL
    let loaderTask: ImageLoaderTask
    var isCanceled: Bool

    init(url: URL, loaderTask: ImageLoaderTask, isCanceled: Bool = false) {
      self.url = url
      self.loaderTask = loaderTask
      self.isCanceled = isCanceled
    }
  }

  typealias CompletionBlock = (_ images: [UIImage]) -> Void

  private var groupTasks = [Int: [Task]]()

  func loadImages(groupId id: Int, urls: [URL], completionHandler: CompletionBlock? = nil) {

    if let tasks = groupTasks[id] {
      if urls != tasks.map { $0.url } {
        for task in tasks {
          task.isCanceled = true
          loader.cancel(task.loaderTask)
        }
        groupTasks.removeValue(forKey: id)
      } else {
        return
      }
    }

    var images = [UIImage](repeating: UIImage(named: "img_template_unknown")!, count: urls.count)
    var tasks = [Task]()
    let group = DispatchGroup()
    for (index, url) in urls.enumerated() {
      group.enter()
      let loaderImage = loader.loadImage(from: url, completionHandler: { image, _ in
        if let image = image {
          images[index] = image
        }
        group.leave()
      })
      let task = Task(url: url, loaderTask: loaderImage)
      tasks.append(task)
    }
    groupTasks[id] = tasks

    group.notify(queue: DispatchQueue.main) {
      for task in tasks where task.isCanceled {
        return
      }

      self.groupTasks.removeValue(forKey: id)
      if let completionHandler = completionHandler {
        completionHandler(images)
      }
    }
  }
}
