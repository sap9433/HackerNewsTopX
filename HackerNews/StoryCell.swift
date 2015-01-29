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
    var storeScore: Int? = userDefault.objectForKey(minscoreKey) as Int?
    
    var storyId : Int? {
        didSet{
            var myRootRef = Firebase(url:"\(individualStoryUrl)\(self.storyId!)")
            // Read data and react to changes
            myRootRef.observeEventType(.Value, withBlock: {
                snapshot in
                var storyDetails :  NSDictionary? = snapshot.value as NSDictionary?
                self.textLabel?.text = storyDetails?["title"] as String?
                let score = storyDetails?["score"] as Int?
                
                if score != nil{
                    if(score! < self.storeScore!){
                        //Dont know how but returning from here just removes that row from table view
                       return
                    }else{
                        self.detailTextLabel?.text = "\(score!)"
                    }
                }
                
            })
        }
    }
    
}
