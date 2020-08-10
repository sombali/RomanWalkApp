//
//  WebViewController.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 05. 14..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var url: URL?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let url = url {
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
    }
}
