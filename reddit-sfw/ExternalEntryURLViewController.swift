//
//  ExternalEntryURLViewController.swift
//  reddit-sfw
//
//  Created by Vrymel Omandam on 26/01/2017.
//  Copyright © 2017 Vrymel Omandam. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ExternalEntryURLViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loadingIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    
    private var _entry: EntryModel!
    
    var entry: EntryModel {
        get {
            return _entry
        }
        set {
            _entry = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingIndicatorView.startAnimating()
        
        webView.delegate = self
        
        let url = URL(string: _entry.url)
        let urlRequest = URLRequest(url: url!)
        
        webView.loadRequest(urlRequest)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadingIndicatorView.stopAnimating()
    }

}
