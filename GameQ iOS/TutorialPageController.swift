//
//  TutorialPageController.swift
//  GameQ iOS
//
//  Created by Ludvig Fröberg on 13/07/15.
//  Copyright (c) 2015 Fabian Wikström. All rights reserved.
//

import UIKit

class TutorialPageController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var pageCount:Int = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors().navTopGray
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    // MARK: - Delegate
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pageCount
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
    
    
    // MARK: - Datasource (required)
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if viewController.isKindOfClass(TutorialController1) {
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tutViewController = storyboard.instantiateViewControllerWithIdentifier("Tutorial2") as! TutorialController2
            return tutViewController
        } else if viewController.isKindOfClass(TutorialController2) {
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tutViewController = storyboard.instantiateViewControllerWithIdentifier("Tutorial3") as! TutorialController3
            return tutViewController
        } else if viewController.isKindOfClass(TutorialController3) {
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tutViewController = storyboard.instantiateViewControllerWithIdentifier("Tutorial4") as! TutorialController4
            return tutViewController
        } else if viewController.isKindOfClass(TutorialController4) {
            return nil
            
        } else {
            return nil
        }
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if viewController.isKindOfClass(TutorialController1) {
            return nil
        } else if viewController.isKindOfClass(TutorialController2) {
            if pageCount == 3 {
                return nil
            }
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tutViewController = storyboard.instantiateViewControllerWithIdentifier("Tutorial1") as! TutorialController1
            return tutViewController
        } else if viewController.isKindOfClass(TutorialController3) {
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tutViewController = storyboard.instantiateViewControllerWithIdentifier("Tutorial2") as! TutorialController2
            return tutViewController
        } else if viewController.isKindOfClass(TutorialController4) {
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tutViewController = storyboard.instantiateViewControllerWithIdentifier("Tutorial3") as! TutorialController3
            return tutViewController
        } else {
            return nil
        }
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }*/


}
