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
                let faviconUrl = "http://" + host + "/favicon.ico"
                
                if let exixtingImg = imageCache[faviconUrl] {
                    self.cellImage.image = exixtingImg
                }else{
                    storyUrlObj = NSURL(string: faviconUrl)
                    var request: NSURLRequest = NSURLRequest(URL: storyUrlObj!)
                    NSURLConnection.sendAsynchronousRequest(request, queue: self.opQueue, completionHandler: {
                        (response: NSURLResponse!, data: NSData!, error: NSError!) in
                        var image: UIImage?
                        if(data != nil){
                            println(data)
                            image = UIImage(data: data)
                        }
                        
                        if(image != nil){
                            NSOperationQueue.mainQueue().addOperationWithBlock(){
                                imageCache[faviconUrl] = image!.cropToCircleWithBorderColor(UIColor.whiteColor(), lineWidth: 0.1)
                                self.setNeedsLayout()
                            }
                        }else{
                            imageCache[faviconUrl] = UIImage(named: "default")
                        }
                    })
                }
            }else{
                self.cellImage.image = UIImage(named: "default")
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
            }else{
                self.title.textColor = UIColor.blueColor()
            }
            self.storyUrl = cellData["url"] as? String
        }
    }
}
