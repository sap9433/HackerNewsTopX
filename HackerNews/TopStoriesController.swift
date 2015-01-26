//
//  TopStoriesController.swift
//  HackerNews
//
//  Created by Saptarshi Chatterjee on 1/26/15.
//  Copyright (c) 2015 Saptarshi Chatterjee. All rights reserved.
//

import UIKit

class TopStoriesController: UITableViewController{
    var data = [Int]()
    let opQueue = NSOperationQueue()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var myRootRef = Firebase(url:"https://hacker-news.firebaseio.com/v0/topstories")
        
        // Read data and react to changes
        myRootRef.observeEventType(.Value, withBlock: {
            snapshot in
            self.data = (snapshot.value as NSArray) as [Int]
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
        let cell = tableView.dequeueReusableCellWithIdentifier("eachStory" , forIndexPath: indexPath) as StoryCell
        var storyUrl = "https://hacker-news.firebaseio.com/v0/item/\(data[indexPath.row])"
        
        cell.operationQ = opQueue
        cell.url = storyUrl
        
        cell.textLabel?.text = "\(data[indexPath.row])"
        return cell
        
        
    }
}
