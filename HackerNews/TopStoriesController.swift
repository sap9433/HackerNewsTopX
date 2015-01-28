//
//  TopStoriesController.swift
//  HackerNews
//
//  Created by Saptarshi Chatterjee on 1/26/15.
//  Copyright (c) 2015 Saptarshi Chatterjee. All rights reserved.
//

import UIKit

let minscoreKey = "minScore"
let topStoriesIdskey = "topStoriesIdskey"
let individualStoryUrl = "https://hacker-news.firebaseio.com/v0/item/"
let userDefault = NSUserDefaults.standardUserDefaults()

class TopStoriesController: UITableViewController{
    
    var data = [Int]()
    let opQueue = NSOperationQueue()
    let cellIdentifier = "eachStory"
    let allStoriesLink = "https://hacker-news.firebaseio.com/v0/topstories"
    
 
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
}
