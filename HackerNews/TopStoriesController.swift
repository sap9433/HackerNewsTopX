//
//  TopStoriesController.swift
//  HackerNews
//
//  Created by Saptarshi Chatterjee on 1/26/15.
//  Copyright (c) 2015 Saptarshi Chatterjee. All rights reserved.
//

import UIKit

let minscoreKey = "minScore"
let cellIdentifier = "eachStory"
let webviewIdentifier = "webview"
let topStoriesIdskey = "topStoriesIdskey"
let allStoriesLink = "https://hacker-news.firebaseio.com/v0/topstories"
let individualStoryUrl = "https://hacker-news.firebaseio.com/v0/item/"
let userDefault = NSUserDefaults.standardUserDefaults()

class TopStoriesController: UITableViewController{
    
    var data = [Int]()
    let opQueue = NSOperationQueue()
    let webViewSegue = "webViewSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var myRootRef = Firebase(url: allStoriesLink)
        
        // Read data and react to changes
        myRootRef.observeEventType(.Value, withBlock: {
            snapshot in
            var topStoriesIds = (snapshot.value as NSArray) as [Int]
            userDefault.setObject(topStoriesIds, forKey: topStoriesIdskey)
            self.data = topStoriesIds
            self.tableView.reloadData()
        })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier( cellIdentifier, forIndexPath: indexPath) as StoryCell
        var storyId = data[indexPath.row] as Int
        
        cell.operationQ = opQueue
        cell.storyId = storyId
        
        cell.textLabel?.text = "\(storyId)"
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // This method will be empty for following overridden method to work we need this empty method.
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var moreRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Original Story", handler:{action, indexpath in
            self.performSegueWithIdentifier(self.webViewSegue, sender: self)
           
        });
        moreRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        return [moreRowAction];
    }
}
