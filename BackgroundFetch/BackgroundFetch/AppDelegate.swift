//
//  AppDelegate.swift
//  BackgroundFetch
//
//  Created by Bas Broek on 05/05/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import UIKit

private let APPROVE_ACTION = "APPROVE_ACTION"
private let VIEW_ACTION = "VIEW_ACTION"
private let NOTIFICATION_CATEGORY = "NOTIFICATION_CATEGORY"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Sound | .Alert | .Badge, categories: nil))
        
        self.createActions()
        
        return true
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void)
    {
        self.registerLocalNotification(["BasThomas": "Dit is een testbericht"])
        
        completionHandler(.NewData)
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void)
    {
        if notification.category == NOTIFICATION_CATEGORY
        {
            switch(identifier!)
            {
                case APPROVE_ACTION:
                    println("approving...")
                    
                case VIEW_ACTION:
                    println("viewing...")
                    
                default:
                    break
            }
        }
        
        completionHandler()
    }
    
    func registerLocalNotification(message: [String: String]?)
    {
        let localNotification = UILocalNotification()
        localNotification.alertAction = "check the message"
        
        let user = message?.keys.first
        let body = message?.values.first
        
        localNotification.alertBody = "\(user!) wrote a new message: \(body!)"
        localNotification.category = NOTIFICATION_CATEGORY
        
        localNotification.fireDate = NSDate()
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func createActions()
    {
        let approveAction = UIMutableUserNotificationAction()
        approveAction.identifier = APPROVE_ACTION
        approveAction.title = "Approve"
        approveAction.activationMode = .Background
        approveAction.authenticationRequired = true
        
        let viewAction = UIMutableUserNotificationAction()
        viewAction.identifier = VIEW_ACTION
        viewAction.title = "View"
        viewAction.activationMode = .Foreground
        viewAction.destructive = false
        
        let notificationCategory = UIMutableUserNotificationCategory()
        notificationCategory.identifier = NOTIFICATION_CATEGORY
        
        notificationCategory.setActions([approveAction, viewAction], forContext: .Minimal)
        
        let types: UIUserNotificationType = .Alert | .Sound
        let settings = UIUserNotificationSettings(forTypes: types, categories: NSSet(object: notificationCategory))
        
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }

    func applicationWillResignActive(application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication)
    {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}