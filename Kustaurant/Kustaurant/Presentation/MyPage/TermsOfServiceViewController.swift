//
//  TermsOfServiceViewController.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/30/24.
//

import UIKit
import WebKit

class TermsOfServiceViewController: NavigationBarLeftBackButtonViewController {
    
    private let viewModel: PlainWebViewLoadViewModel
    private let termsOfServiceView = TermsOfServiceView()
    
    init(viewModel: PlainWebViewLoadViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    override func loadView() {
        view = termsOfServiceView
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = "이용약관"
    }
}

extension TermsOfServiceViewController {
    
    private func setupWebView() {
        termsOfServiceView.webView.navigationDelegate = self
        if let url = URL(string: viewModel.webViewUrl) {
            let request = URLRequest(url: url)
            termsOfServiceView.webView.load(request)
        }
    }
}

extension TermsOfServiceViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            if let url = navigationAction.request.url {
                webView.load(URLRequest(url: url))
            }
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}

