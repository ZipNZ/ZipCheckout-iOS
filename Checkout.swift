//
//  Checkout.swift
//  ZipCheckout-iOS
//
//  Created by Scott Murray on 6/04/21.
//

import Foundation

/// Initiates the Zip Nz checkout flow
class Checkout {

  private var auth0Client: Auth0Client
  private var _itemName: String
  private var _amount: Int
  private var _redirectSuccessUrl: String = "https://sandbox.zip.co/nz/api?yay=true"
  private var _redirectFailureUrl: String = "https://sandbox.zip.co/nz/api?yay=false"

  init(
    _ clientId: String, _ clientSecret: String, _ auth0Domain: String, _ auth0Audience: String,
    _ amount: Int, _ itemName: String
  ) {
    self.auth0Client = Auth0Client(clientId, clientSecret, auth0Domain, auth0Audience)

    self._amount = amount
    self._itemName = itemName
  }

  /**
     Initiates the checkout flow and calls the completion method once checkout has started
     */
  func startCheckout(_ completion: @escaping (ZipWebViewRedirect) -> Void) {
    self.auth0Client.acquireToken { response in
      do {
        let token = try response.get().access_token
        let zipNzClient = ZipNzClient(token)
        zipNzClient.createOrder(
          self._itemName, self._amount, self._redirectSuccessUrl, self._redirectFailureUrl
        ) {
          response in
          switch response {
          case .success(let response):
            completion(
              ZipWebViewRedirect(
                redirectUrl: response.redirectUrl, successUrl: self._redirectSuccessUrl,
                failureUrl: self._redirectFailureUrl))
            return
          case .failure(_):
            print("Error occured creating order")
          }
        }
      } catch {
        print("Could not retrieve access token")
      }
    }
  }
}
