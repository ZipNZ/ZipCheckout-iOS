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

  private var _loadingAnimationService: LoadingAnimationService = LoadingAnimationService()

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

  override func viewDidAppear(_ animated: Bool) {
    _loadingAnimationService.addCurrentView(self)
    _loadingAnimationService.animate(true)
  }

  public func webView(
    _ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void
  ) {

    if !self.isIframeRequest(navigationAction) {
      _loadingAnimationService.animate(true)
    }

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

  public func webView(_ webView: WKWebView, didStartProvisionalNavigation: WKNavigation) {
    _loadingAnimationService.animate(true)
  }

  public func webView(_ webView: WKWebView, didCommit: WKNavigation) {
    _loadingAnimationService.animate(true)
  }

  public func webView(_ webView: WKWebView, didFinish: WKNavigation) {
    _loadingAnimationService.animate(false)
  }

  private func dismissWithStatus(_ status: String) {
    if let presenter = presentingViewController as? CheckoutController {
      presenter.completionStatus = status
      dismiss(animated: true, completion: nil)
    }
  }

  private func isIframeRequest(_ navAction: WKNavigationAction) -> Bool {
    guard let isMainFrameRequest = navAction.targetFrame?.isMainFrame else {
      return false
    }
    return !isMainFrameRequest
  }

  override func viewDidDisappear(_ animated: Bool) {
    self.webviewProtocol?.onCompletion()
  }

}
