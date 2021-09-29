//
//  ArticleDetailsViewController.swift
//  TipranksNews
//
//  Created by Adi Lior on 27/09/2021.
//

import UIKit
import WebKit

class ArticleDetailsViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicatorView: UIView!
    
    var articleViewModel: ArticleViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        setupUI()
        loadWebView()
    }
    
    private func setupUI() {
        navigationItem.title = "Article Details"
        
        activityIndicatorView.layer.cornerRadius = 8.0
        activityIndicatorView.layer.borderWidth = 1.0
        activityIndicatorView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func loadWebView() {
        if let urlLink = articleViewModel?.link, let link = URL(string: urlLink) {
            let request = URLRequest(url: link)
            webView.load(request)
        }
    }
    
    deinit{
       webView = nil
    }
}

// MARK:- WKNavigationDelegate
extension ArticleDetailsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicatorView.isHidden = true
    }
}

