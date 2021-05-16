//
//  ViewRecipeViewController.swift
//  XPIRE
//
//  Created by Mando Quintana on 4/23/21.
//

import UIKit
import WebKit
//
//struct recipeUrl: Codable {
//    let sourceUrl: String
//}

class ViewRecipeViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var activityView: UIActivityIndicatorView!
    var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
        init(url: URL){
            self.url = url
            super.init(nibName: nil, bundle: nil)
        }
    //
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView
    }
    
    func showActivityIndicator() {
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }
    
    func stopShowingActivityIndicator(){
        activityView.stopAnimating()
        activityView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       stopShowingActivityIndicator()
    }

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(webView)
//        webView.load(URLRequest(url:url))
//    }
//
//    init(url: URL){
//        self.url = url
//        super.init(nibName: nil, bundle: nil)
//    }
////
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private let webView: WKWebView = {
//        let preferences = WKWebpagePreferences()
//        preferences.allowsContentJavaScript = true
//        let configuration = WKWebViewConfiguration()
//        let webView = WKWebView(frame: .zero, configuration: configuration)
//
//        return webView
//    }()
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        webView.frame = view.bounds
//    }
//
}
