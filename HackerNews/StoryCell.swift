//
//  StoryCell.swift
//  HackerNews
//
//  Created by Saptarshi Chatterjee on 1/26/15.
//  Copyright (c) 2015 Saptarshi Chatterjee. All rights reserved.
//

import UIKit

class StoryCell: UITableViewCell {
    
    var cellDetails: AnyObject?{
        didSet{
            var cellData = self.cellDetails as NSDictionary
            self.textLabel?.text = cellData["title"] as? String //self.cellDetails![self.storyId].title
        }
    }
    
    var storyId : Int? {
        didSet{
            
        }
    }
    
}
