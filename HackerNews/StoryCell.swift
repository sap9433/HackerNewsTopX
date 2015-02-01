//
//  StoryCell.swift
//  HackerNews
//
//  Created by Saptarshi Chatterjee on 1/26/15.
//  Copyright (c) 2015 Saptarshi Chatterjee. All rights reserved.
//

import UIKit

class StoryCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var by: UILabel!
    
    var cellDetails: AnyObject?{
        didSet{
            var cellData = self.cellDetails as NSDictionary
            self.title.text = cellData["title"] as? String
            self.details.text = cellData["text"] as? String
            var score = cellData["score"] as Int
            self.score.text = String(score)
            self.by.text = cellData["by"] as? String
        }
    }
    
    var storyId : Int? {
        didSet{
            
        }
    }
    
}
