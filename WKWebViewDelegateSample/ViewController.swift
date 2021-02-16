//
//  ViewController.swift
//  WKWebViewDelegateSample
//
//  Created by Yuichi Fujiki on 15/2/21.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: view.bounds)

        webView.navigationDelegate = self

        view.addSubview(webView)

        webView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://resourceloadfailure.web.app/index.html")!
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension ViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        NSLog("%% Did commit navigation for \(String(describing: webView.url)) \(navigation.debugDescription)")
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        NSLog("%% Did start provisional navigation for \(String(describing: webView.url)) \(navigation.debugDescription)")
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        NSLog("%% Did receive server redirect for provisional navigation for \(String(describing: webView.url)) \(navigation.debugDescription)")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        NSLog("%% Did fail navigation for \(String(describing: webView.url)) \(navigation.debugDescription)")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {

        NSLog("%% Did fail provisional navigation for \(String(describing: webView.url)) \(navigation.debugDescription)")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        NSLog("%% Did finish navigation for \(String(describing: webView.url)) \(navigation.debugDescription)")
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        NSLog("%% Process did terminate navigation for \(String(describing: webView.url))")
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let url = navigationResponse.response.url?.absoluteString ?? ""
        let statusCode = (navigationResponse.response as? HTTPURLResponse)?.statusCode ?? -1
        let isForMainFrame = navigationResponse.isForMainFrame
        NSLog("%% Decide Policy For response url \(url)")
        NSLog("%% \tStatus code: \(statusCode)")
        NSLog("%% \tMain Frame?: \(isForMainFrame)")
        switch statusCode {
        case 200..<400:
            decisionHandler(.allow)
        default:
            decisionHandler(.cancel)
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let newWindow = navigationAction.targetFrame == nil
        NSLog("%% Decide Policy For action")
        NSLog("%% \tNew Window?: \(newWindow)")
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        let contentMode = preferences.preferredContentMode
        let allowJavaScript = preferences.allowsContentJavaScript
        let newWindow = navigationAction.targetFrame == nil
        NSLog("%% Decide Policy For action and preferences")
        NSLog("%% \tContentMode: \(contentMode)")
        NSLog("%% \tJavaScript: \(allowJavaScript)")
        NSLog("%% \tNew Window?: \(newWindow)")
        decisionHandler(.allow, preferences)
    }
}

