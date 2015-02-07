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
            if let host = storyUrlObj!.host{
                let faviconUrl:String = "http://\(host)/favicon.ico"
                
                if let exixtingImg = imageCache[faviconUrl] {
                    if(self.details.text == nil || self.details.text == ""){
                        self.cellImage.hidden = false
                        self.cellImage.image = exixtingImg
                    }else{
                        self.cellImage.hidden = true
                    }
                    
                }else{
                    self.cellImage.hidden = true
                    storyUrlObj = NSURL(string: faviconUrl)
                    var request: NSURLRequest = NSURLRequest(URL: storyUrlObj!)
                    NSURLConnection.sendAsynchronousRequest(request, queue: self.opQueue, completionHandler: {
                        (response: NSURLResponse!, data: NSData!, error: NSError!) in
                        var image: UIImage?
                        if(data != nil){
                            image = UIImage(data: data)
                        }
                        
                        if(image != nil){
                            NSOperationQueue.mainQueue().addOperationWithBlock(){
                                imageCache[faviconUrl] = image!.cropToCircleWithBorderColor(UIColor.whiteColor(), lineWidth: 0.1)
                                notificationCenter.postNotificationName("refreshTable", object: nil)
                            }
                        }else{
                            imageCache[faviconUrl] = defaultImage
                        }
                    })
                }
            }else{
                
                self.cellImage.hidden = true
            }
        }
    }
    
    var cellDetails: AnyObject?{
        didSet{
            if let cellData = self.cellDetails as NSDictionary?{
                self.title.text = cellData["title"] as? String
                self.details.text = cellData["text"] as? String
                var score = cellData["score"] as Int
                self.score.text = String(score)
                var submitionTime = cellData["time"]! as NSTimeInterval
                var dateParse = NSDate(timeIntervalSince1970: submitionTime)
                var byAndDate = dateParse.timeAgo + " By "
                byAndDate += cellData["by"] as String
                self.by.text = byAndDate
                if let visited =  cellData["visited"] as? Bool{
                    self.title.textColor = visitedColor
                    self.by.textColor = visitedColor
                    self.score.textColor = visitedColor
                }else{
                    self.title.textColor = UIColor.blackColor()
                }
                self.storyUrl = cellData["url"] as? String
            }
        }
    }
}
