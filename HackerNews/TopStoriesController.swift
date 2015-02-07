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
            if let storySavedData = userDefault.objectForKey("HN\(storyId)") as NSMutableDictionary?{
                storySavedData["visited"] = true
                userDefault.setObject(storySavedData, forKey: "HN\(storyId)")
            }
            let focusUrl = storyDetailsDict["url"] as String
            webview.url = focusUrl
            
        }
    }
    
    func processTopStory(notification: NSNotification){
        // Read data and react to changes
      
        for eachStory in topStoriesIds{
            
            var minscore:Int
            if let storedScore = userDefault.objectForKey(minscoreKey) as Int?{
                minscore = storedScore
            }else{
                minscore = 0
            }
            
            if let storyExists = self.showStories[eachStory]{
                if(storyExists["score"] as Int > minscore){
                    continue
                }else{
                    self.showStories[eachStory] = nil
                    self.tableView.reloadData()
                }
            }else{
                var fetchEachStory = Firebase(url:"\(self.individualStoryUrl)\(eachStory)")
                // Read data and react to changes
                fetchEachStory.observeEventType(.Value, withBlock: {
                    snapshot in
                    if snapshot.exists(){
                        let storyDetails = snapshot.value as NSMutableDictionary?
                        let storyScore = storyDetails!["score"] as Int?
                        var thisStory = eachStory
                        if storyScore? > minscore{
                            self.showStories[thisStory] = storyDetails
                            userDefault.setObject(["notified": true], forKey: "HN\(thisStory)")
                            self.tableLoading.stopAnimating()
                            var notifictionString = storyDetails!["title"] as String + "(\(storyScore!))"
                            self.soretedKeysOnScore()
                            self.sendNotification(notifictionString)
                        }else{
                            self.showStories[thisStory] = nil
                        }
                        self.tableView.reloadData()
                    }
                    
                })
            }
        }
    }
    
    private func sendNotification(notificationText: String){
        pushNotification.alertBody = notificationText
        pushNotification.fireDate = nil
        UIApplication.sharedApplication().scheduleLocalNotification(pushNotification)
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

