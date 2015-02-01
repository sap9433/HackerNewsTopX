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
    var rowInFocus:Int = 0
    let userDefault = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var tableLoading: UIActivityIndicatorView!
    required init(coder aDecoder: NSCoder) {
        self.showStories = [Int: NSDictionary]()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
            self.rowInFocus = indexPath.row
            self.performSegueWithIdentifier(self.webViewSegue, sender: self)
           
        });
        moreRowAction.backgroundColor = UIColor.greenColor()
        
        return [moreRowAction];
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == webViewSegue) {
            var webview = segue.destinationViewController as Webview
            var storyId = Array(showStories.keys)[rowInFocus] as Int
            let focusUrl = (showStories[storyId] as NSDictionary!)["url"] as String
            webview.url = focusUrl
            
        }
    }
    
    func processTopStory(notification: NSNotification){
        // Read data and react to changes
      
        for eachStory in topStoriesIds{
            //let storyExists: AnyObject = showStories[eachStory]
            if false{
                continue
            }else{
                var fetchEachStory = Firebase(url:"\(self.individualStoryUrl)\(eachStory)")
                // Read data and react to changes
                fetchEachStory.observeEventType(.Value, withBlock: {
                    snapshot in
                    if snapshot.exists(){
                        var minscore:Int
                        if let storedScore = self.userDefault.objectForKey(minscoreKey) as Int?{
                            minscore = storedScore
                        }else{
                            minscore = 0
                        }
                        let storyDetails = snapshot.value as NSDictionary?
                        let score = storyDetails!["score"] as Int?
                        var thisStory = eachStory
                        if score? > minscore{
                            self.showStories[thisStory] = storyDetails
                            self.tableLoading.stopAnimating()
                            self.tableView.reloadData()
                        }else{
                            self.showStories[thisStory] = nil
                        }
                    }
                    
                })
            }
        }
    }
}

