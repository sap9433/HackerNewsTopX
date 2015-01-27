//
//  StoryCell.swift
//  HackerNews
//
//  Created by Saptarshi Chatterjee on 1/26/15.
//  Copyright (c) 2015 Saptarshi Chatterjee. All rights reserved.
//

import UIKit

class StoryCell: UITableViewCell {
    
    var operationQ : NSOperationQueue?
    
    var url : String? {
        didSet{
            var myRootRef = Firebase(url:self.url?)
            
            // Read data and react to changes
            myRootRef.observeEventType(.Value, withBlock: {
                snapshot in
                var storyDetails :  NSDictionary = snapshot.value as NSDictionary
                self.textLabel?.text = storyDetails["title"] as String?
                
                if let score = storyDetails["score"] as Int?{
                    self.detailTextLabel?.text = "\(score)"
                }
                
            })
        }
    }
    
    
    
}
