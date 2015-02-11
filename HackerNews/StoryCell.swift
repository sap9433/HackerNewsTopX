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
                //Story url is proper url and we can retrieve host from it.
                let faviconUrl:String = "http://\(host)/favicon.ico"
                
                //Image for this story already exixts in our cache ...
                if let exixtingImg = imageCache[faviconUrl] {
                    //If there is detailed text as well in this story , we gonna hide image..
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
                        
                        //It's an async block .. We received the response,But what if by now we already got response from some other async block for
                        //the same url (yes it's happening) .. so check once if the data already exixts and yes discard this response..
                        if( imageCache[faviconUrl] != nil){
                            //By the time this async block finished we already got response from other block
                            return
                        }
                        
                        if(data != nil){
                            image = UIImage(data: data)
                        }
                        // Even if data is not nill still image can be nil because of corrupt data .. so checking again..
                        if(image != nil){
                            //Yahooo... Image exixts , store it in master Cache and ask the table to refresh so that it's visible...
                            imageCache[faviconUrl] = image!.cropToCircleWithBorderColor(UIColor.whiteColor(), lineWidth: 0.1)
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock(){
                                notificationCenter.postNotificationName("refreshTable", object: nil)
                            }
                        }else{
                            //We tried fetching image , got nil . Now next time it will make a network connection again ,but will probably get nil
                            //cause no favicon exixts at the default location .. so just assign a blank image to this url.
                            imageCache[faviconUrl] = defaultImage
                        }
                    })
                }
            }else{
                //Sory url is not there. Cant fetch any image ..so just hide it.
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
                //everytime a cell is repainted this gets called . check ifits visy=ted . If yes paint gray.
                if let savedData =  userDefault.objectForKey("HN\(storyId!)") as NSMutableDictionary? {
                    if (savedData["visited"] as Bool? != nil) {
                        self.title.textColor = visitedColor
                    }else{
                        self.title.textColor = UIColor.blackColor()
                    }
                    
                }else{
                    self.title.textColor = UIColor.blackColor()
                }
                self.storyUrl = cellData["url"] as? String
            }
        }
    }
}
