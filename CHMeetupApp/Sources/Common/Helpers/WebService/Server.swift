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

  init(apiBase: String) {
    self.apiBase = apiBase
  }

  func request<T: PlainObjectType>(_ request: Request<[T]>, completion: @escaping (([T]?, ServerError?) -> Void)) {
    loadRequest(request) { (jsonObject, error) in
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
    loadRequest(request) { (jsonObject, error) in
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

  private func loadRequest<T>(_ request: Request<T>, completion: @escaping ((Any?, ServerError?) -> Void)) {
    guard Reachability.isInternetAvailable else {
      completion(nil, .noConnection)
      return
    }

    guard let query = URL(string: apiBase + request.query) else {
      print("Session query url faild: base \(apiBase) and query \(request.query)")
      completion(nil, .requestFailed)
      return
    }
    var sessionRequest = URLRequest(url: query)

    sessionRequest.httpMethod = request.method.string
    sessionRequest.httpBody = request.params?.httpQuery
    let loadSession = URLSession.shared.dataTask(with: sessionRequest) { data, _, error in
      guard error == nil else {
        print("Session request error: \(error) for api resourse: \(request)")
        return
      }

      guard let data = data else {
        completion(nil, .emptyResponse)
        return
      }

      let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])

      completion(jsonObject, nil)
    }

    loadSession.resume()
  }
}
