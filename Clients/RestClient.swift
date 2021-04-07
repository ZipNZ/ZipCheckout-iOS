//
//  RestClient.swift
//  ZipCheckout-iOS
//
//  Created by Scott Murray on 6/04/21.
//

import Foundation

/// Bare-bone Rest Client implementation
public class RestClient {

  func sendPostRequest<T>(_ request: URLRequest, _ completion: @escaping (Result<T, Error>) -> Void)
  where T: Decodable {

    print(request)
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let data = data {
        do {
          let responseObject = try JSONDecoder().decode(T.self, from: data)
          completion(.success(responseObject))
          return
        } catch {
          completion(.failure(error))
          return
        }
      } else if let error = error {
        completion(.failure(error))
        return
      }
    }

    task.resume()
  }
}
