//
//  ViewController.swift
//  HackerNews
//
//  Created by Saptarshi Chatterjee on 1/25/15.
//  Copyright (c) 2015 Saptarshi Chatterjee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var minScoreLabel: UILabel!
    var userDefault:NSUserDefaults!
    var notificatioCenter:NSNotificationCenter!
    
    required init(coder aDecoder: NSCoder) {
        self.userDefault = NSUserDefaults.standardUserDefaults()
        self.notificatioCenter = NSNotificationCenter.defaultCenter()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let storeScore = self.userDefault.objectForKey(minscoreKey) as Float?{
            slider.value = storeScore
        }else{
            slider.value = 0.0
        }
        minScoreLabel.text = "\(Int(slider.value))"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func minScoreChanged(sender: UISlider) {
        userDefault.setObject(Int(slider.value), forKey: minscoreKey)
        minScoreLabel.text = "\(Int(slider.value))"
    }
    
    override func viewWillDisappear(animated: Bool) {
        notificatioCenter.postNotificationName("topStoryChanged", object: nil)
    }
    
}

