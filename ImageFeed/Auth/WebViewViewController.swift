//
//  WebViewController.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 12.04.2025.
//

import UIKit
import WebKit

// MARK: - Constants

enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let redirectPath = "/oauth/authorize/native"
}

// MARK: - Delegate Protocol

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
}

// MARK: - WebViewViewController

final class WebViewViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressViewStyle = .default
        progressView.progressTintColor = .ypBlack
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
        
    }()
    
    // MARK: - Properties
    
    weak var delegate: WebViewViewControllerDelegate?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
        setupLayout()
        setupVebView()

        loadAuthView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView
            .addObserver(
                self,
                forKeyPath: #keyPath(WKWebView.estimatedProgress),
                options: .new,
                context: nil
            )
        updateProgress()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    // MARK: - Setup
    
    private func setupAppearance() {
        view.backgroundColor = .ypWhite
    }
    
    private func setupLayout() {
        configureWebView()
        configureProgressView()
    }
    
    private func setupVebView() {
        webView.navigationDelegate = self
    }
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectUri),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
        updateProgress()
    }
    
    // MARK: Progress Handling
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(
                forKeyPath: keyPath,
                of: object,
                change: change,
                context: context
            )
        }
    }

    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1) <= 0.001
    }
    
    //MARK: - Configuration UI Elements
    
    private func configureProgressView() {
        view.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureWebView() {
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor
                .constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }

}

//MARK: - WKNavigationDelegate

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
            guard
                let url = navigationAction.request.url,
                let components = URLComponents(string: url.absoluteString),
                components.path == WebViewConstants.redirectPath
            else { return nil }

            return components.queryItems?.first(where: { $0.name == "code" })?.value
        }
}
