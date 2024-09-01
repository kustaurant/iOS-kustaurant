//
//  PrivacyPolicyViewController.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/30/24.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController {
    
    private let viewModel: PlainWebViewLoadViewModel
    private let privacyPolicyView = PrivacyPolicyView()
    
    init(viewModel: PlainWebViewLoadViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupWebView()
    }
    
    override func loadView() {
        view = privacyPolicyView
    }
}

extension PrivacyPolicyViewController {
    
    private func setupWebView() {
        privacyPolicyView.webView.navigationDelegate = self
        if let url = URL(string: viewModel.webViewUrl) {
            let request = URLRequest(url: url)
            privacyPolicyView.webView.load(request)
        }
    }
    
    private func setupNavigationBar() {
        let backImage = UIImage(named: "icon_back")
        let backButtonView = UIImageView(image: backImage)
        let backButton = UIBarButtonItem(customView: backButtonView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        backButtonView.addGestureRecognizer(tapGesture)
        backButtonView.isUserInteractionEnabled = true
        navigationItem.title = "개인정보처리방침"
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        viewModel.didTapBackButton()
    }
}

extension PrivacyPolicyViewController: WKNavigationDelegate {
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


