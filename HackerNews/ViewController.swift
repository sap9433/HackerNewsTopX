//
//  ViewController.swift
//  HackerNews
//
//  Created by Saptarshi Chatterjee on 1/25/15.
//  Copyright (c) 2015 Saptarshi Chatterjee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var minScore: UISlider!
    @IBOutlet weak var minScoreLabel: UILabel!
    
    let userDefault = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var storeScore: Float? = self.userDefault.objectForKey(minscoreKey) as Float?
        minScore.value = storeScore!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func minScoreChanged(sender: UISlider) {
        userDefault.setObject(minScore.value, forKey: minscoreKey)
        minScoreLabel.text = "See and get update of stories with score > \(minScore.value)"
    }
}

