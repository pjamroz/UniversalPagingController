//
//  AppDelegate.swift
//  UniversalPagingControllerDemo
//
//  Created by Piotr Jamróz on 24.07.2016.
//  Copyright © 2016 Piotr Jamróz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // Create 3 sample view controllers
        let redViewController = UIViewController()
        redViewController.view.backgroundColor = UIColor.redColor()
        let blueViewController = UIViewController()
        blueViewController.view.backgroundColor = UIColor.blueColor()
        let greenViewController = UIViewController()
        greenViewController.view.backgroundColor = UIColor.greenColor()
        
        // Create universal paging controller with sample view controllers
        let pagingViewController = UniversalPagingController.createWithViewControllers([redViewController, blueViewController, greenViewController])
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let window = appDelegate.window
        
        
        // Check if controller was created
        if pagingViewController != nil {
            window?.rootViewController = pagingViewController
        }
        
        self.window?.makeKeyAndVisible()
        
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

