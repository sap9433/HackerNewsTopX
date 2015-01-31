//
//  StoryCell.swift
//  HackerNews
//
//  Created by Saptarshi Chatterjee on 1/26/15.
//  Copyright (c) 2015 Saptarshi Chatterjee. All rights reserved.
//

import UIKit

class StoryCell: UITableViewCell {
    
    var cellDetails: [String: Any]?{
        didSet{
            self.textLabel?.text = "yo \(self.storyId)" //self.cellDetails![self.storyId].title
        }
    }
    
    var storyId : Int? {
        didSet{
            
        }
    }
    
}
