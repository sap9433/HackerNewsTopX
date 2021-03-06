//
//  AppDelegate.swift
//  HackerNews
//
//  Created by Saptarshi Chatterjee on 1/25/15.
//  Copyright (c) 2015 Saptarshi Chatterjee. All rights reserved.
//

import UIKit

var topStoriesIds = [Int]()
let minscoreKey = "minScore"
var imageCache = [String:UIImage]()
var notificationCenter = NSNotificationCenter.defaultCenter()
let defaultImage = UIImage()
let visitedColor = UIColor.grayColor().colorWithAlphaComponent(0.7)
let userDefault = NSUserDefaults.standardUserDefaults()
let qualityOfServiceClass = QOS_CLASS_BACKGROUND
let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let allStoriesLink = "https://hacker-news.firebaseio.com/v0/topstories"
        var fireBase = Firebase(url: allStoriesLink)
        
        dispatch_async(backgroundQueue, {
            fireBase.observeEventType(.Value, withBlock: {
                snapshot in
                var rawValues = (snapshot.value as NSArray) as [Int]
                rawValues.sort(>)
                //read firebase.com/docs/ios/guide/retrieving-data.html. Value bind gets called repetatively avoid same data processing .
                if(topStoriesIds != rawValues){
                    topStoriesIds = rawValues
                    notificationCenter.postNotificationName("topStoryChanged", object: nil)
                }
            })
            return
        })
        
        
        
        // Notification ...
        let notificationType = UIUserNotificationType.Alert | UIUserNotificationType.Badge
        let notificationSetting = UIUserNotificationSettings(forTypes: notificationType, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSetting)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

