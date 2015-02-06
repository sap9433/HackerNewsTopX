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
    var imageCache:[String: UIImage]?
    
    var storyUrl: String?{
        didSet{
            //This commented out code is for image in story cell. wont execute
            var storyUrlObj = NSURL(string: self.storyUrl!)
            var faviconUrl : String
            if let host = storyUrlObj!.host{
                faviconUrl = "http://" + host + "/favicon.ico"
            }else{
                return
            }
            
            if let exixtingUmg = imageCache?[faviconUrl] {
                self.cellImage.image = exixtingUmg.cropToCircleWithBorderColor(UIColor.whiteColor(), lineWidth: 0.1)
                self.setNeedsLayout()
            }else{
                self.cellImage.image = nil
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
                            
                            //self.cellImage.image = image!.cropToCircleWithBorderColor(UIColor.whiteColor(), lineWidth: 0.1)
                            self.imageCache?[faviconUrl] = image!
                            self.setNeedsLayout()
                        }
                    }
                })
            }
        }
    }
    
    var cellDetails: AnyObject?{
        didSet{
            var cellData = self.cellDetails as NSDictionary
            self.title.text = cellData["title"] as? String
            self.details.text = cellData["text"] as? String
        
//             This commented out code is for image in story cell
//            if storyDetails != nil && storyDetails! != ""{
//                self.details.text! = storyDetails!
//                self.cellImage.hidden = true
//            }else{
//                self.details.hidden = true
//            }
            var score = cellData["score"] as Int
            self.score.text = String(score)
            var submitionTime = cellData["time"]! as NSTimeInterval
            var dateParse = NSDate(timeIntervalSince1970: submitionTime)
            var byAndDate = dateParse.timeAgo + " By "
            byAndDate += cellData["by"] as String
            self.by.text = byAndDate
            if let visited =  cellData["visited"] as? Bool{
                self.title.textColor = UIColor.blackColor()
            }
            //This commented out code is for image in story cell
            //self.storyUrl = cellData["url"] as? String
        }
    }
}
