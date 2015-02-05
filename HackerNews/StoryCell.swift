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
    @IBOutlet weak var cellImage: UIImageView!
    var opQueue: NSOperationQueue?
    var storyId : Int?
    
    var storyUrl: String?{
        didSet{
            var storyUrlObj = NSURL(string: self.storyUrl!)
            var faviconUrl = "http://" + storyUrlObj!.host! + "/favicon.ico"
            storyUrlObj = NSURL(string: faviconUrl)
            var request: NSURLRequest = NSURLRequest(URL: storyUrlObj!)
            
            NSURLConnection.sendAsynchronousRequest(request, queue: self.opQueue, completionHandler: {
                (response: NSURLResponse!, data: NSData!, error: NSError!) in
                var image = UIImage(data: data)
                NSOperationQueue.mainQueue().addOperationWithBlock(){
                    self.cellImage.image = image
                    self.setNeedsLayout()
                }
            })
        }
    }
    
    var cellDetails: AnyObject?{
        didSet{
            var cellData = self.cellDetails as NSDictionary
            self.title.text = cellData["title"] as? String
            let details = cellData["text"] as? String
            
            
            if details != nil && details! != ""{
                self.details.text = details
                println("yo" + details!)
                self.cellImage.hidden = true
            }else{
                self.details.hidden = true
//                var img = UIImage(named: "default")
//                self.cellImage.image = img!.cropToCircleWithBorderColor(UIColor.whiteColor(), lineWidth: 0.1)
            }
            var score = cellData["score"] as Int
            self.score.text = String(score)
            var submitionTime = cellData["time"]! as NSTimeInterval
            var dateParse = NSDate(timeIntervalSince1970: submitionTime)
            var byAndDate = dateParse.timeAgo + " By "
            byAndDate += cellData["by"] as String
            self.by.text = byAndDate
            if storyUrl == nil{
                self.storyUrl = cellData["url"] as? String
            }
        }
    }
}
