//
//  SocialNetwork.swift
//  CHMeetupApp
//
//  Created by Sergey Zapuhlyak on 07/03/2017.
//  Copyright © 2017 Sergey Zapuhlyak. All rights reserved.
//

import Foundation

class SocialNetwork {

  func requestWithMethod(_ method: String, path: String, parameters: [String: Any], baseURL: NSURL) -> URLRequest {

    let url = NSURL(string: path, relativeTo: baseURL.absoluteURL)

    var request = URLRequest(url: (url?.absoluteURL)!)
    request.httpMethod = method
    request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
    request.timeoutInterval = 10.0

    if parameters.count != 0 {
      let connector = path.range(of: "?") == nil ? "?" : "&"
      let path = (url?.absoluteString)! + connector + parameters.queryString
      request.url = NSURL(string: path)?.absoluteURL
    }

    return request
  }

  func sendRequest<T: SocialRequestProtocol>(_ request: T, urlRequest:URLRequest) where T: SocialRequest {

    let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
      if request.isResponseJSON {
        do {
          if let parameters = try JSONSerialization.jsonObject(with: data!,
                                                               options: .mutableContainers) as? [String: Any] {
            request.response = request.buildResponse(parameters) as? SocialResponse
            request.success?(request)
          } else {
            request.failure?(request, error)
          }

        } catch {
          request.failure?(request, error)
        }
      } else {
        let responseString = String(data: data!, encoding: .utf8)!
        let parameters = responseString.queryStringParameters
        request.response = request.buildResponse(parameters) as? SocialResponse
        request.success?(request)
      }
    }

    task.resume()
  }
}
