//
//  AppDelegate.swift
//  GameQ iOS
//
//  Created by Fabian Wikström on 6/25/15.
//  Copyright (c) 2015 Fabian Wikström. All rights reserved.
//

import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainViewController:MainViewController = MainViewController()
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        println("launching")
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound |
            UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
        
        application.registerForRemoteNotifications()
        application.setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        application.statusBarStyle = UIStatusBarStyle.LightContent
        
        if let launchOs = launchOptions {
            var alert = UIAlertController(title: "GameQ", message: launchOs.description, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            
        }

        if let tmp = ConnectionHandler.loadEmail() {
            if tmp.validEmail() {
                
                ////
                var storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainViewController = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
                let leftViewController = storyboard.instantiateViewControllerWithIdentifier("LeftViewController") as! LeftViewController
                let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
                leftViewController.mainViewController = nvc
                let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
                window!.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
                window!.rootViewController = slideMenuController
                window!.makeKeyAndVisible()
                ////
                
                
                
                ConnectionHandler.firstLogin = true
                ConnectionHandler.loginWithRememberedDetails({
                    (success:Bool, error:String?) in
                    dispatch_async(dispatch_get_main_queue()) {
                        ConnectionHandler.firstLogin = false
                        if success {
                            //stay on main view
                            // do nothing
                        } else {
                            //if credentials no longer viable
                            //logout
                            var storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let loginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                            UIApplication.sharedApplication().delegate?.window?!.rootViewController = loginViewController
                            UIApplication.sharedApplication().delegate?.window?!.makeKeyAndVisible()
                        }
                    }
                })
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        return true
    }
    
    // MARK: - Push notifications
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        println("got Push inApp")
        var message:String = "Your queue has ended!"
        println("what am i getting? \(userInfo)")
        if let aps:Dictionary<String, AnyObject> = userInfo["aps"] as AnyObject? as? Dictionary<String, AnyObject> {
            println("aps dictionary constructed")
            println("aps: \(aps)")
            if let alert:String = aps["alert"] as? String {
                message = alert
            }
            if ( application.applicationState == UIApplicationState.Inactive || application.applicationState == UIApplicationState.Background  )
            {
                //opened from a push notification when the app was on background
            } else {
                if let sound:String = aps["sound"] as? String {
                    var soundID:SystemSoundID = SystemSoundID()
                    let soundArr = split(sound) {$0 == "."}
                    let path = NSBundle.mainBundle().pathForResource(soundArr[0], ofType: soundArr[1])
                    var bodyf:NSFileHandle = NSFileHandle(forReadingAtPath: path!)!
                    let body = bodyf.availableData
                    let url = NSURL(fileURLWithPath: path!, isDirectory: false)
                    AudioServicesCreateSystemSoundID(url as! CFURLRef, &soundID)
                    AudioServicesPlaySystemSound(soundID)
                }
            }
            
        }
        if let acceptBefore:Int = userInfo["accept_before"] as AnyObject? as? Int {
            mainViewController.startReadyCountdown(acceptBefore)
            println("accept time:")
            println(acceptBefore - Int(NSDate().timeIntervalSince1970))
        }
        /*
        var alert = UIAlertController(title: "GameQ", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)*/
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        println("APNS register successful")
        
        let newToken:String = deviceToken.description.stringByReplacingOccurrencesOfString("<", withString: "").stringByReplacingOccurrencesOfString(">", withString: "").stringByReplacingOccurrencesOfString(" ", withString: "")
        if let oldToken:String = ConnectionHandler.loadToken() {
            println("newToken: \(newToken) oldToken: \(oldToken)")
            if newToken == oldToken {
                println("same old token as usual")
                
                //if token exists and is same, do nothing
                return
            }
            ConnectionHandler.saveToken(newToken)
            if let dummy:String = ConnectionHandler.loadEmail() {// if logged in 1
                if dummy.validEmail() {// if logged in 2
                    ConnectionHandler.updateToken(newToken, finalCallBack: {
                        (success:Bool, error:String?) in
                        if success {
                            println("successfully updated token")
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                println("Unsuccessful token update")
                                var alert = UIAlertController(title: "GameQ", message: "There were difficulties connecting to the server. Push notifications may not be received properly.", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
                            })
                        }
                    })
                }
            }
            
            println("replacing old token \(oldToken) with new token \(newToken)")
            return
        }
        
        ConnectionHandler.saveToken(newToken)
        println("saving token")
        return
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("APNS did fail to rgister for remote notifications with error: \(error)")
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "GameQ.GameQ_iOS" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("GameQ_iOS", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("GameQ_iOS.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}

