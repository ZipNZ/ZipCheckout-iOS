//
//  ViewController.swift
//  ZipCheckout-iOS
//
//  Created by Scott Murray on 6/04/21.
//

import UIKit
import WebKit

class ZipWebViewController: UIViewController, WKNavigationDelegate {

  var webView: WKWebView!
  var checkoutUrl: String = "sandbox.zip.co/nz/api"
  var successRedirect: String = ""
  var failureRedirect: String = ""

  weak var webviewProtocol: ZipWebViewRedirectProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()

    let url = URL(string: checkoutUrl)!
    webView.load(URLRequest(url: url))
    webView.allowsBackForwardNavigationGestures = true
  }

  override func loadView() {
    webView = WKWebView()
    webView.navigationDelegate = self
    view = webView
  }

  public func webView(
    _ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void
  ) {

    if navigationAction.request.url != nil {
      if navigationAction.request.url!.absoluteString.contains(self.successRedirect) {
        print("Successful order")
        dismissWithStatus("Success!")

      }

      if navigationAction.request.url!.absoluteString.contains(self.failureRedirect) {
        print("Failed order")
        dismissWithStatus("Failure")
      }
    }

    decisionHandler(.allow)
  }

  private func dismissWithStatus(_ status: String) {
    if let presenter = presentingViewController as? CheckoutController {
      presenter.completionStatus = status
      dismiss(animated: true, completion: nil)
    }
  }

  override func viewDidDisappear(_ animated: Bool) {
    self.webviewProtocol?.onCompletion()
  }
}
