//
//  TopStoriesController.swift
//  HackerNews
//
//  Created by Saptarshi Chatterjee on 1/26/15.
//  Copyright (c) 2015 Saptarshi Chatterjee. All rights reserved.
//

import UIKit


class TopStoriesController: UITableViewController{
    let individualStoryUrl:String
    let cellIdentifier:String
    let topStoriesIdskey:String
    let webViewSegue:String
    let interActedWithApp:String
    var showStories:[Int: NSMutableDictionary]
    var rowInFocus:Int
    var pushNotification: UILocalNotification
    var opQueue:NSOperationQueue
    var sortedKey: [Int]
    
    @IBOutlet weak var tableLoading: UIActivityIndicatorView!
    
    required init(coder aDecoder: NSCoder) {
        self.individualStoryUrl = "https://hacker-news.firebaseio.com/v0/item/"
        self.cellIdentifier = "eachStory"
        self.topStoriesIdskey = "topStoriesIdskey"
        self.webViewSegue = "webViewSegue"
        self.interActedWithApp = "interActedWithApp"
        self.rowInFocus = 0
        self.sortedKey = []
        
        self.showStories = [Int: NSMutableDictionary]()
        self.pushNotification = UILocalNotification()
        self.opQueue = NSOperationQueue()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.addObserver(self, selector: "processTopStory:", name:"topStoryChanged", object: nil)
        defaultCenter.addObserver(self, selector: "refreshTable:", name:"refreshTable", object: nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showStories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier( cellIdentifier, forIndexPath: indexPath) as StoryCell
        var storyId = sortedKey[indexPath.row] as Int
        cell.opQueue = opQueue
        cell.storyId = storyId
        cell.cellDetails = showStories[storyId]
        return cell
    }
    
    // This method will be empty for following overridden method to work we need this empty method.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    //this is the overridden method that handels the table row action
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var moreRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Original Story", handler:{action, indexpath in
            self.rowInFocus = indexPath.row
            self.performSegueWithIdentifier(self.webViewSegue, sender: self)
            
        });
        moreRowAction.backgroundColor = visitedColor
        
        return [moreRowAction];
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == webViewSegue) {
            var webview = segue.destinationViewController as Webview
            var storyId = sortedKey[rowInFocus] as Int
            var storyDetailsDict = showStories[storyId] as NSMutableDictionary!
            if let storySavedData = userDefault.objectForKey("HN\(storyId)") as NSDictionary?{
                var immutableData = storySavedData.mutableCopy() as NSMutableDictionary
                immutableData["visited"] = true
                userDefault.setObject(immutableData, forKey: "HN\(storyId)")
            }
            let focusUrl = storyDetailsDict["url"] as String
            //webview.url = focusUrl;
            var newUrl = NSURL(string: focusUrl)
            UIApplication.sharedApplication().openURL(newUrl!)
            
            //mark user has made an interaction with app
            userDefault.setObject(true, forKey: interActedWithApp)
        }
    }
    
    func processTopStory(notification: NSNotification){
        // Read data and react to changes
        
        dispatch_async(backgroundQueue, {
            for eachStory in topStoriesIds{
                //If the story details already exixts in the master record (i.e. showStories)
                if let storyExists = self.showStories[eachStory]{
                    //story score is more than the filter score. do nothing ...
                    if(storyExists["score"] as Int? > userDefault.objectForKey(minscoreKey) as Int?){
                        continue
                    }else{
                        //story score is less than the filter score. remove the story from master record ...
                        self.showStories[eachStory] = nil
                    }
                }else{
                    //story details doesn't exixt in master record ... it's time to fetch..
                    var fetchEachStory = Firebase(url:"\(self.individualStoryUrl)\(eachStory)")
                    // Read data and react to changes
                    fetchEachStory.observeEventType(.Value, withBlock: {
                        snapshot in
                        if snapshot.exists(){
                            let storyDetails = snapshot.value as NSMutableDictionary?
                            let storyScore = storyDetails!["score"] as Int?
                            // closure outside values getting reset .
                            var thisStory = storyDetails!["id"] as Int
                            if storyScore? > userDefault.objectForKey(minscoreKey) as Int?{
                                //this is value bind , Will get called repetatively if some of he story details changes
                                if let existsInMasterRecord = self.showStories[thisStory]{
                                    // this data alredy exixts in master record and score hasn't changed , no point reprocessing.
                                    if(existsInMasterRecord["score"] as Int? == storyDetails!["score"] as Int?){
                                        return
                                    }
                                }
                                self.showStories[thisStory] = storyDetails
                                self.tableLoading.stopAnimating()
                                var notifictionString = storyDetails!["title"] as String + "(\(storyScore!))"
                                self.soretedKeysOnScore()
                                self.sendNotification(notifictionString, thisStoryId: thisStory)
                                //Save that a notification been sent
                                userDefault.setObject(["notified": true], forKey: "HN\(thisStory)")
                                //new fetched value added to table so refresh the data
                                dispatch_async(dispatch_get_main_queue(), {
                                    notificationCenter.postNotificationName("refreshTable", object: nil)
                                })
                            }
                        }
                    })
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                notificationCenter.postNotificationName("refreshTable", object: nil)
            })
        })
        
    }
    
    private func sendNotification(notificationText: String, thisStoryId: Int){
        //only start sending notification if user have interacted with the app
        if let savedData =  userDefault.objectForKey(interActedWithApp) as Bool? {
            if  let savedData =  userDefault.objectForKey("HN\(thisStoryId)") as NSMutableDictionary?{
                if(savedData["notified"] as Bool? == nil){
                    pushNotification.alertBody = notificationText
                    pushNotification.fireDate = nil
                    UIApplication.sharedApplication().scheduleLocalNotification(pushNotification)
                }
            }
        }
    }
    
    func refreshTable(notification: NSNotification){
        self.tableView.reloadData()
    }
    
    
    private func soretedKeysOnScore() {
        var dictKeys = Array(showStories.keys)
        var sortedKeys: () = sort(&dictKeys) {
            var firstVal:Int?
            var secondVal:Int?
            if let firstScore = self.showStories[$0]{
                firstVal = firstScore["score"] as? Int
            }
            if let nextScore = self.showStories[$1]{
                secondVal = nextScore["score"] as? Int
            }
            
            return firstVal > secondVal
        }
        sortedKey = dictKeys
    }
}

