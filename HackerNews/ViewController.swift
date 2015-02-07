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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let storeScore = userDefault.objectForKey(minscoreKey) as Float?{
            slider.value = storeScore
        }else{
            slider.value = 0.0
        }
        minScoreLabel.text = "Story score \(Int(slider.value))"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func minScoreChanged(sender: UISlider) {
        userDefault.setObject(Int(slider.value), forKey: minscoreKey)
        minScoreLabel.text = "Story score \(Int(slider.value))"
    }
    
    override func viewWillDisappear(animated: Bool) {
        notificationCenter.postNotificationName("topStoryChanged", object: nil)
    }
    
}

