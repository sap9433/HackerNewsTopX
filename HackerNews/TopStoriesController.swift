//
//  TopStoriesController.swift
//  HackerNews
//
//  Created by Saptarshi Chatterjee on 1/26/15.
//  Copyright (c) 2015 Saptarshi Chatterjee. All rights reserved.
//

import UIKit


class TopStoriesController: UITableViewController{
    let individualStoryUrl = "https://hacker-news.firebaseio.com/v0/item/"
    let cellIdentifier = "eachStory"
    let topStoriesIdskey = "topStoriesIdskey"
    let webViewSegue = "webViewSegue"
    var showStories:[Int: NSDictionary]
    let userDefault = NSUserDefaults.standardUserDefaults()
        
    var minSetScore = 1
    
    required init(coder aDecoder: NSCoder) {
        self.showStories = [Int: NSDictionary]()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Read data and react to changes
        let storedScore: Int? = userDefault.objectForKey(minscoreKey) as Int?
        if storedScore != nil{
           self.minSetScore = storedScore!
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "processTopStory:", name:"topStoryChanged", object: nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showStories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier( cellIdentifier, forIndexPath: indexPath) as StoryCell
        var storyId = Array(showStories.keys)[indexPath.row] as Int
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
            self.performSegueWithIdentifier(self.webViewSegue, sender: self)
           
        });
        moreRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        return [moreRowAction];
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == webViewSegue) {
            var webview = segue.destinationViewController as Webview;
            webview.url = "https://news.ycombinator.com/"
            
        }
    }
    
    func processTopStory(notification: NSNotification){
        for eachStory in topStoriesIds{
            if let storyExists: AnyObject = showStories[eachStory]{
                continue
            }else{
                var fetchEachStory = Firebase(url:"\(self.individualStoryUrl)\(eachStory)")
                // Read data and react to changes
                fetchEachStory.observeEventType(.Value, withBlock: {
                    snapshot in
                    if snapshot.exists(){
                        println(snapshot)
                        let storyDetails = snapshot.value as NSDictionary?
                        let score = storyDetails!["score"] as Int?
                        var thisStory = eachStory
                        if score? > self.minSetScore{
                            self.showStories[thisStory] = storyDetails
                        }
                    }
                    
                })
            }
        }
    }
}

