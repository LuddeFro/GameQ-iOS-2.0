//
//  LoginViewController.swiftLogInButton
//  GameQ iOS
//
//  Created by Fabian Wikström on 6/27/15.
//  Copyright (c) 2015 Fabian Wikström. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var pwIcon: UIImageView!
    @IBOutlet weak var confirmIcon: UIImageView!
    @IBOutlet weak var btnBottom: LogInButton!
    @IBOutlet weak var btnTop: LogInButton!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var txtEmail: GQTextField!
    @IBOutlet weak var txtPassword: GQTextField!
    @IBOutlet weak var txtConfirmPassword: GQTextField!
    @IBOutlet weak var btnForgot: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnResignKeyboard: UIButton!
    var bolReportingForgottenPassword:Bool = false
    var bolSigningUp:Bool = false
    
    @IBOutlet weak var statusYMargin: NSLayoutConstraint!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors().MainGray
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        self.setNeedsStatusBarAppearanceUpdate()
        
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    @IBAction func pressedResignKeyboard(sender: AnyObject) {
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        txtConfirmPassword.resignFirstResponder()
    }
    
    @IBAction func pressedBottomButton(sender: AnyObject) {
        if bolReportingForgottenPassword {
            hideForgotPassword()
            bolReportingForgottenPassword = false
        } else if bolSigningUp {
            hideSignUp()
            bolSigningUp = false
        } else {
            showSignUp()
            bolSigningUp = true
        }
    }
    @IBAction func pressedTopButton(sender: AnyObject) {
        if bolReportingForgottenPassword {
            //reporting forgotten pass
            if !txtEmail.text.validEmail() {
                lblStatus.text = "Invalid e-mail address."
                lblStatus.textColor = Colors().Orange
            } else {
                disableAll()
                ConnectionHandler.forgotPassword(txtEmail.text, finalCallBack: {
                    (success:Bool, error:String?) in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.enableAll()
                        if success {
                            self.lblStatus.text = "A new password has been sent to your e-mail address."
                            self.lblStatus.textColor = Colors().LightBlue
                        } else {
                            self.lblStatus.text = error!
                            self.lblStatus.textColor = Colors().Orange
                        }
                    }
                    
                })
            }
            
        } else if bolSigningUp {
            //signing up
            if !txtEmail.text.validEmail() {
                lblStatus.text = "Invalid e-mail address."
            } else if !txtPassword.text.validPassword() {
                lblStatus.text = "Invalid password, must contain at least 6 characters."
                txtPassword.text = ""
            } else if txtPassword.text != txtConfirmPassword.text {
                lblStatus.text = "Passwords do not match"
                txtPassword.text = ""
                txtConfirmPassword.text = ""
            } else {
                disableAll()
                ConnectionHandler.register(txtEmail.text, password: txtPassword.text, finalCallBack: {
                    (success:Bool, error:String?) in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.enableAll()
                        if success {
                            if ConnectionHandler.firstLaunch() {
                                var storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let tutViewController = storyboard.instantiateViewControllerWithIdentifier("TutorialPageControl") as! TutorialPageController
                                tutViewController.delegate = tutViewController
                                tutViewController.dataSource = tutViewController
                                UIApplication.sharedApplication().delegate?.window?!.rootViewController = tutViewController
                                UIApplication.sharedApplication().delegate?.window?!.makeKeyAndVisible()
                                
                                let tutViewController1 = storyboard.instantiateViewControllerWithIdentifier("Tutorial1") as! TutorialController1
                                
                                tutViewController.setViewControllers([tutViewController1], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: {
                                    (success:Bool) in
                                    println("setup pageController")
                                })
                            } else {
                                self.createMainView()
                            }
                        } else {
                            self.lblStatus.text = error!
                        }
                    }
                })
            }
            
        } else {
            //signing in
            if !txtEmail.text.validEmail() {
                lblStatus.text = "Invalid e-mail address."
            } else if !txtPassword.text.validPassword() {
                lblStatus.text = "Invalid password, must contain at least 6 characters."
                txtPassword.text = ""
            } else {
                disableAll()
                println("trying login")
                ConnectionHandler.login(txtEmail.text, password: txtPassword.text, finalCallBack: {
                    (success:Bool, error:String?) in
                    println("returned from login")
                    self.enableAll()
                    dispatch_async(dispatch_get_main_queue()) {
                        self.enableAll()
                        if success {
                            //go to main menu
                            if ConnectionHandler.firstLaunch() {
                                var storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let tutViewController = storyboard.instantiateViewControllerWithIdentifier("TutorialPageControl") as! TutorialPageController
                                tutViewController.delegate = tutViewController
                                tutViewController.dataSource = tutViewController
                                UIApplication.sharedApplication().delegate?.window?!.rootViewController = tutViewController
                                UIApplication.sharedApplication().delegate?.window?!.makeKeyAndVisible()
                                
                                let tutViewController1 = storyboard.instantiateViewControllerWithIdentifier("Tutorial1") as! TutorialController1
                                
                                tutViewController.setViewControllers([tutViewController1], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: {
                                    (success:Bool) in
                                    println("setup pageController")
                                })
                            } else {
                                self.createMainView()
                            }
                        } else {
                            self.lblStatus.text = error!
                        }
                    }
                })
            }
        }
        println("top button pressed")
    }
    
    @IBAction func pressedForgotPassword(sender: AnyObject) {
        showForgotPassword()
        bolReportingForgottenPassword = true
    }
    
    func hideErrors() {
        txtEmail.hideError()
        txtPassword.hideError()
        txtConfirmPassword.hideError()
        lblStatus.text = ""
    }
    
    
    func showSignUp() {
        println("showS")
        UIView.setAnimationsEnabled(false)

        self.btnBottom.setTitle("Back", forState: UIControlState.Normal)
        self.btnTop.setTitle("Join", forState: UIControlState.Normal)
        UIView.setAnimationsEnabled(true)
        self.btnBottom.layoutIfNeeded()
        self.btnTop.layoutIfNeeded()
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.txtConfirmPassword.alpha = 1.0
            self.lblStatus.text = ""
            self.btnForgot.alpha = 0.0
            self.statusYMargin.constant += 47
            self.txtConfirmPassword.text = ""
            self.confirmIcon.alpha = 1.0
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func hideSignUp() {
        println("hideS")
        self.txtConfirmPassword.text = ""
        UIView.setAnimationsEnabled(false)
        self.btnBottom.setTitle("Join", forState: UIControlState.Normal)
        self.btnTop.setTitle("Sign In", forState: UIControlState.Normal)
        UIView.setAnimationsEnabled(true)
        self.btnBottom.layoutIfNeeded()
        self.btnTop.layoutIfNeeded()

        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.txtConfirmPassword.alpha = 0.0
            self.btnForgot.alpha = 1.0
            self.statusYMargin.constant -= 47
            self.lblStatus.text = ""
            self.confirmIcon.alpha = 0.0
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func showForgotPassword() {
        println("showF")
        UIView.setAnimationsEnabled(false)
        self.btnBottom.setTitle("Back", forState: UIControlState.Normal)
        self.btnTop.setTitle("Submit Email", forState: UIControlState.Normal)
        UIView.setAnimationsEnabled(true)
        self.btnBottom.layoutIfNeeded()
        self.btnTop.layoutIfNeeded()
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.statusYMargin.constant -= 47
            self.btnForgot.alpha = 0.0
            self.lblStatus.text = ""
            self.txtPassword.text = ""
            self.txtPassword.alpha = 0.0
            self.pwIcon.alpha = 0.0
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func hideForgotPassword() {
        println("hideF")
        
        
        
        /*UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseIn, animations: {
            self.btnBottom.titleLabel?.alpha = 0
            self.btnTop.titleLabel?.alpha = 0
            }, completion: { (success:Bool) in
                UIView.setAnimationsEnabled(false)
                self.btnBottom.setTitle("Join", forState: UIControlState.Normal)
                self.btnTop.setTitle("Sign In", forState: UIControlState.Normal)
                UIView.setAnimationsEnabled(true)
                self.btnBottom.layoutIfNeeded()
                self.btnTop.layoutIfNeeded()
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
                    self.btnBottom.titleLabel?.alpha = 1
                    self.btnTop.titleLabel?.alpha = 1
                }, completion:nil)
                
        })*/
        UIView.setAnimationsEnabled(false)
        self.btnBottom.setTitle("Join", forState: UIControlState.Normal)
        self.btnTop.setTitle("Sign In", forState: UIControlState.Normal)
        UIView.setAnimationsEnabled(true)
        self.btnBottom.layoutIfNeeded()
        self.btnTop.layoutIfNeeded()
        
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.statusYMargin.constant += 47
            self.btnForgot.alpha = 1.0
            self.lblStatus.text = ""
            self.lblStatus.textColor = Colors().Orange
            self.txtPassword.alpha = 1.0
            self.pwIcon.alpha = 1.0
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        
        
        
    }
    
    private func createMainView() {
        
        // create viewController code...
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        let leftViewController = storyboard.instantiateViewControllerWithIdentifier("LeftViewController") as! LeftViewController
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        leftViewController.mainViewController = nvc
        
        let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        
        UIApplication.sharedApplication().delegate?.window?!.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        UIApplication.sharedApplication().delegate?.window?!.rootViewController = slideMenuController
        UIApplication.sharedApplication().delegate?.window?!.makeKeyAndVisible()
        UIApplication.sharedApplication().statusBarHidden = false
    }
    
    private func disableAll() {
        btnTop.enabled = false
        btnBottom.enabled = false
        btnForgot.enabled = false
        txtEmail.enabled = false
        txtPassword.enabled = false
        txtConfirmPassword.enabled = false
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        activityIndicator.alpha = 1.0
    }
    
    private func enableAll() {
        btnTop.enabled = true
        btnBottom.enabled = true
        btnForgot.enabled = true
        txtEmail.enabled = true
        txtPassword.enabled = true
        txtConfirmPassword.enabled = true
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
        activityIndicator.alpha = 0.0
    }
    
    
    
    //MARK UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == txtEmail {
            if bolReportingForgottenPassword {
                pressedTopButton(btnTop)
            } else {
                txtPassword.becomeFirstResponder()
            }
        } else if textField == txtPassword {
            if bolSigningUp {
                txtConfirmPassword.becomeFirstResponder()
            } else {
                pressedTopButton(btnTop)
            }
        } else if textField == txtConfirmPassword {
            pressedTopButton(btnTop)
        }
        return false
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        btnResignKeyboard.hidden = false

    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        btnResignKeyboard.hidden = true
        textField.resignFirstResponder()

    }
    
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        println("Will show")
        println(UIScreen.mainScreen().bounds.height - 200)
        
        
        if bolReportingForgottenPassword {
            println("movingforgotten")
            if UIScreen.mainScreen().bounds.height - keyboardFrame.size.height - 20 < txtEmail.frame.origin.y + txtEmail.frame.height {
                println("will move")
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.bottomConstraint.constant = -(UIScreen.mainScreen().bounds.height - keyboardFrame.size.height - 20 - self.txtEmail.frame.origin.y - self.txtEmail.frame.height)
                    self.view.layoutIfNeeded()
                })
            }
        } else if bolSigningUp {
            println("movingsignup")
            if UIScreen.mainScreen().bounds.height - keyboardFrame.size.height - 20 < txtConfirmPassword.frame.origin.y + txtConfirmPassword.frame.height {
                println("will move")
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.bottomConstraint.constant = -(UIScreen.mainScreen().bounds.height - keyboardFrame.size.height - 20 - self.txtConfirmPassword.frame.origin.y - self.txtConfirmPassword.frame.height)
                    self.view.layoutIfNeeded()
                })
            }
        } else {
            println("movingsignin")
            if UIScreen.mainScreen().bounds.height - keyboardFrame.size.height - 20 < txtPassword.frame.origin.y + txtPassword.frame.height {
                println("will move")
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.bottomConstraint.constant = -(UIScreen.mainScreen().bounds.height - keyboardFrame.size.height - 20 - self.txtPassword.frame.origin.y - self.txtPassword.frame.height)
                    self.view.layoutIfNeeded()
                })
            }
        }
        
        
        
        
        
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = 5
            self.view.layoutIfNeeded()
        })
    }
    
                                             
    
    
}




