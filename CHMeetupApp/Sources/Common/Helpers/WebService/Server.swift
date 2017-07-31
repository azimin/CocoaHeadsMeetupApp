//
//  WebService.swift
//  CHMeetupApp
//
//  Created by Sam on 24/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

enum ServerError: Error {
  case noConnection
  case requestFailed
  case emptyResponse
  case wrongResponse

  var desc: String {
    switch self {
    case .requestFailed:
      return "ServerError.requestFailed".localized
    case .noConnection:
      return "ServerError.noConnection".localized
    case .emptyResponse:
      return "ServerError.emptyResponse".localized
    case .wrongResponse:
      return "ServerError.wrongResponse".localized
    }
  }
}

class Server {
  let apiBase: String

  static var standard: Server {
    return Server(apiBase: Constants.apiBase)
  }

  typealias DataTaskIdentifier = Int
  fileprivate var dataTaskContainter: [DataTaskIdentifier: URLSessionDataTask]?

  init(apiBase: String) {
    self.apiBase = apiBase
  }

  func request<T: PlainObjectType>(_ request: Request<[T]>, completion: @escaping (([T]?, ServerError?) -> Void)) {
    loadRequest(request) { jsonObject, error in
      guard let jsonObject = jsonObject else {
        completion(nil, error)
        return
      }

      if let parser = request.parser {
        let values = parser.parseLogic(jsonObject)
        completion(values.0, values.1)
        return
      }

      if let json = jsonObject as? [JSONDictionary] {
        let objects: [T] = Array(json: json)
        completion(objects, nil)
      } else {
        completion(nil, .wrongResponse)
      }
    }
  }

  func request<T: PlainObjectType>(_ request: Request<T>, completion: @escaping ((T?, ServerError?) -> Void)) {
    loadRequest(request) { jsonObject, error in
      guard let jsonObject = jsonObject else {
        completion(nil, error)
        return
      }

      if let parser = request.parser {
        let values = parser.parseLogic(jsonObject)
        completion(values.0, values.1)
        return
      }

      if let json = jsonObject as? JSONDictionary {
        let value = T(json: json)
        completion(value, nil)
      } else {
        completion(nil, .wrongResponse)
      }
    }
  }

  var lastDataTaskIdentifier: DataTaskIdentifier? {
    guard let lastIndex = dataTaskContainter?.endIndex else {
      return nil
    }
    return dataTaskContainter?.keys[lastIndex]
  }

  private func loadRequest<T>(_ request: Request<T>, completion: @escaping ((Any?, ServerError?) -> Void)) {
    guard Reachability.isInternetAvailable else {
      completion(nil, .noConnection)
      return
    }

    if request.method == .get, request.params != nil {
      fatalError("Get query should not have params. Use request url for sending any parameters.")
    }

    guard let query = URL(string: apiBase + request.query) else {
      print("Session query url failed: base \(apiBase) and query \(request.query)")
      completion(nil, .requestFailed)
      return
    }
    var sessionRequest = URLRequest(url: query)

    sessionRequest.httpMethod = request.method.string
    sessionRequest.httpBody = request.params?.httpQuery
    sessionRequest.timeoutInterval = Constants.Server.baseRequestTimeout

    var loadSession: URLSessionDataTask!
    loadSession = URLSession.shared.dataTask(with: sessionRequest) { [weak self] (data, _, error) in
      defer {
        self?.dataTaskContainter?.removeValue(forKey: loadSession.taskIdentifier)
      }

      guard error == nil else {
        print("Session request error: \(String(describing: error)) for api resourse: \(request)")
        return
      }
      guard let data = data else {
        OperationQueue.main.addOperation {
          completion(nil, .emptyResponse)
        }
        return
      }

      #if DEBUG
      let responseString = String(data: data, encoding: .utf8) ?? ""
      print("Query: \(query.absoluteString)\nResponse: \n\(responseString)\n---------")
      #endif

      let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])

      OperationQueue.main.addOperation {
        completion(jsonObject, nil)
      }
    }
    dataTaskContainter?[loadSession.taskIdentifier] = loadSession
    loadSession.resume()
  }

// MARK: - Cancel Requests

  func cancelDataTask(with identifier: DataTaskIdentifier) {
    if let dataTask: URLSessionDataTask = dataTaskContainter?[identifier] {
      dataTask.cancel()
    }
  }

}
