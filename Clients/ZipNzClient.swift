//
//  ZipNzClient.swift
//  ZipCheckout-iOS
//
//  Created by Scott Murray on 6/04/21.
//

import Foundation

/// An example of how to interact with the ZipNz API
///
/// IMPORTANT NOTE -
/// we would want to create the order on a backend rather than the client
/// application. This is purely to keep the example fairly self contained
public class ZipNzClient: RestClient {
  private var _accessToken: String
  private var _apiInstance: String = "sandbox.zip.co/nz/api"
  private var _jsonEncoder: JSONEncoder = JSONEncoder()
  private var _jsonDecoder: JSONDecoder = JSONDecoder()

  init(_ accessToken: String) {
    self._accessToken = accessToken
  }

  func createOrder(
    _ itemName: String, _ amount: Int, _ redirectConfirmUrl: String, _ redirectCancelUrl: String,
    _ completion: @escaping (Result<CreateOrderResponse, Error>) -> Void
  ) {

    // Set consumer.email to autofill the checkout screens email address field
    let orderPayload = """
      {
          "amount": \(amount),
          "consumer": {
              "phoneNumber": "0200000000",
              "givenNames": "John",
              "surname": "Smith"
          },
          "billing": {
              "addressLine1": "Address Line 1",
              "addressLine2": "Suite 1",
              "suburb": "Auckland",
              "postcode": "1000"
          },
          "shipping": {
              "addressLine1": "Address Line 1",
              "addressLine2": "Suite 1",
              "suburb": "Auckland",
              "postcode": "1000"
          },
          "description": "A purchase of a new iPhone X.",
          "items": [
              {
                  "name": "Apple iPhone X (256GB, Black)",
                  "sku": "M/X1824C",
                  "quantity": 1,
                  "price": \(amount),
                  "merchantChannel": "iStore"
              }
          ],
          "merchant": {
              "redirectConfirmUrl": "\(redirectConfirmUrl)",
              "redirectCancelUrl": "\(redirectCancelUrl)"
          },
          "merchantReference": "x-ios-example-application",
          "taxAmount": 40,
          "shippingAmount": 0
      }
      """

    var request = URLRequest(
      url: URL(string: "https://\(self._apiInstance)/order")!)

    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    request.addValue("Bearer \(self._accessToken)", forHTTPHeaderField: "Authorization")

    request.httpMethod = "POST"

    do {
      let order = try _jsonDecoder.decode(Order.self, from: Data(orderPayload.utf8))
      request.httpBody = try _jsonEncoder.encode(order)
    } catch {
      print(error)
      completion(.failure(error))
      return
    }

    super.sendPostRequest(request, completion)
  }
}
