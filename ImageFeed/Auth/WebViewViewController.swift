//
//  WebViewController.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 12.04.2025.
//

import UIKit
import WebKit

// MARK: - Constants



// MARK: - WebViewViewControllerProtocol

protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
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
        webView.accessibilityIdentifier = "UnsplashWebView"
        
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
    var presenter: WebViewPresenterProtocol?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProgressObservation()

        setupAppearance()
        setupLayout()
        setupWebViewDelegate()

        presenter?.viewDidLoad()
        
    }

    // MARK: - Setup
    
    private func setupAppearance() {
        view.backgroundColor = .ypWhite
    }
    
    private func setupLayout() {
        setupWebView()
        setupProgressView()
    }
    
    private func setupWebViewDelegate() {
        webView.navigationDelegate = self
    }
    
    // MARK: Progress Handling
    
    func setupProgressObservation() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self else { return }
                 self.presenter?
                     .didUpdateProgressValue(self.webView.estimatedProgress)
             }
        )
    }
    
    //MARK: - Configuration UI Elements
    
    private func setupProgressView() {
        view.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupWebView() {
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
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
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
}

// MARK: - WebViewViewControllerProtocol

extension WebViewViewController: WebViewViewControllerProtocol {
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
}
