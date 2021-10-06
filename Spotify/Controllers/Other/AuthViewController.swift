//
//  AuthViewController.swift
//  Spotify
//
//  Created by William Tristão de Pauloa on 04/10/21.
//

import UIKit
import WebKit

class AuthViewController: UIViewController {
    
    var successHandler: ((Bool) -> Void)?
    
    private let webview: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        
        let webview = WKWebView.init(frame: .zero, configuration: config)
        
        return webview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        view.addSubview(webview)
        webview.navigationDelegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        webview.frame = view.bounds
        
        guard let URL = AuthManager.shared.signInURL else {
            return
        }
        
        webview.load(URLRequest(url: URL))
    }
    
}

extension AuthViewController: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        guard let url = webview.url else {
            return
        }
        
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: {$0.name == "code"})?.value else {
            return
        }
        
        AuthManager.shared.exchangeCodeForToken(code: code) {[weak self] success in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
                self?.successHandler?(success)
            }
        }
    }
    
}
