//
//  TutorialController4.swift
//  GameQ iOS
//
//  Created by Ludvig Fröberg on 13/07/15.
//  Copyright (c) 2015 Fabian Wikström. All rights reserved.
//

import UIKit

class TutorialController4: UIViewController {

    
    @IBAction func pressedBackToMain(sender: AnyObject) {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        let leftViewController = storyboard.instantiateViewControllerWithIdentifier("LeftViewController") as! LeftViewController
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        leftViewController.mainViewController = nvc
        
        let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        
        UIApplication.sharedApplication().delegate?.window?!.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        UIApplication.sharedApplication().delegate?.window?!.rootViewController = slideMenuController
        UIApplication.sharedApplication().delegate?.window?!.makeKeyAndVisible()
    }
}
