//
//  Auth0Client.swift
//  ZipCheckout-iOS
//
//  Created by Scott Murray on 6/04/21.
//

import Foundation

/// Simple Auth0 Client implementation
///
/// IMPORTANT NOTE -
/// we would want to retrieve the access token from a backend in reality.
/// This is purely to keep the example fairly self contained

class Auth0Client: RestClient {

  private var _clientId: String
  private var _clientSecret: String
  private var _jsonEncoder = JSONEncoder()
  var auth0Domain: String
  var auth0Audience: String

  init(_ clientId: String, _ clientSecret: String, _ auth0Domain: String, _ auth0Audience: String) {
    self._clientId = clientId
    self._clientSecret = clientSecret
    self.auth0Domain = auth0Domain
    self.auth0Audience = auth0Audience
  }

  /**
     Retrieves an Auth0TokenResponse object
     */
  func acquireToken(completion: @escaping (Result<Auth0TokenResponse, Error>) -> Void) {

    let auth0TokenRequest = Auth0TokenRequest(
      self._clientId, self._clientSecret, "https://\(self.auth0Audience)", "client_credentials")

    var request = URLRequest(
      url: URL(string: "https://\(self.auth0Domain)/oauth/token")! 
    )

    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"

    do {
      request.httpBody = try _jsonEncoder.encode(auth0TokenRequest)
    } catch {
      completion(.failure(error))
      return
    }

    super.sendPostRequest(request, completion)
  }

}
