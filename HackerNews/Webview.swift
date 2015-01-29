//
//  Webview.swift
//  HackerNews
//
//  Created by Saptarshi Chatterjee on 1/29/15.
//  Copyright (c) 2015 Saptarshi Chatterjee. All rights reserved.
//

import UIKit

class Webview: UIViewController {
    
    @IBOutlet weak var webpage: UIWebView!
    var url : String?
    
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

}
