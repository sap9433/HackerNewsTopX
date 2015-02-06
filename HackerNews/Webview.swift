//
//  Webview.swift
//  HackerNews
//
//  Created by Saptarshi Chatterjee on 1/29/15.
//  Copyright (c) 2015 Saptarshi Chatterjee. All rights reserved.
//

import UIKit

class Webview: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var pageLoading: UIActivityIndicatorView!
    @IBOutlet weak var webpage: UIWebView!
    var url : String?
    
    var notificatioCenter:NSNotificationCenter!
    
    required init(coder aDecoder: NSCoder) {
        self.notificatioCenter = NSNotificationCenter.defaultCenter()
        super.init(coder: aDecoder)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let requestUrl = NSURL(string: url!)
        let request = NSURLRequest(URL: requestUrl!)
        webpage.loadRequest(request)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func webViewDidFinishLoad(webView: UIWebView!) {
        pageLoading.stopAnimating()
    }
    
    override func viewWillDisappear(animated: Bool) {
        notificatioCenter.postNotificationName("refreshTable", object: nil)
    }


}
