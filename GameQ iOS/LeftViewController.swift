//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit
import MessageUI

class LeftViewController : UIViewController, UITextViewDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var leftNavBar: UIView!
    
    @IBOutlet weak var pwIcon1: UIImageView!
    @IBOutlet weak var pwIcon2: UIImageView!
    @IBOutlet weak var pwIcon3: UIImageView!
    @IBOutlet weak var onButtonOne: OnButton!
    @IBOutlet weak var offButtonOne: OffButton!
    @IBOutlet weak var onButtonThree: OnButton!
    @IBOutlet weak var offButtonThree: OffButton!
    @IBOutlet weak var lblUserEmail: MenuLabel!
    @IBOutlet weak var btnLogout: LogOutButton!

    @IBOutlet weak var btnResignFirstResponder: UIButton!
    @IBOutlet weak var btnTutorial: UIButton!
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var btnFeedback: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    @IBOutlet weak var labelFour: UILabel!
    @IBOutlet weak var labelFive: UILabel!
    @IBOutlet weak var labelSix: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var feedbackHeight: NSLayoutConstraint!
    @IBOutlet weak var changePasswordHeight: NSLayoutConstraint!
    @IBOutlet weak var txtOldPassword: GQTextField!
    @IBOutlet weak var txtNewPassword: GQTextField!
    @IBOutlet weak var txtConfirmPassword: GQTextField!
    @IBOutlet weak var txtFeedback: UITextView!

    @IBOutlet weak var btnSubmitFeedback: UIButton!
    @IBOutlet weak var btnSubmitPassword: SubmitButton!

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var bolChangingPassword:Bool = false
    var bolGivingFeedback:Bool = false
    
    var currentTextField:UIView = UIView()
    
    static let emptyString:String = "nonsense"
    
    @IBOutlet weak var viewLoginBackground: UIView!
    
    
    
    @IBAction func pressedMail(sender: AnyObject) {
        let emailTitle = "Contact from iOS"
        let body = ""
        let recipients:[AnyObject] = ["contact@gameq.io"]
        var mc:MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(body, isHTML: false)
        mc.setToRecipients(recipients)
        self.presentViewController(mc, animated: true, completion: nil)
        
    }
    @IBAction func pressedFacebook(sender: AnyObject) {
        let facebookURL = NSURL(string: "fb://profile/304122193079686")!
        if UIApplication.sharedApplication().canOpenURL(facebookURL) {
            UIApplication.sharedApplication().openURL(facebookURL)
        } else {
            UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/GameQApp")!)
        }
    }
    
    @IBAction func pressedTwitter(sender: AnyObject) {
        let twitterURL = NSURL(string: "twitter:///user?screen_name=GameQApp")!
        if UIApplication.sharedApplication().canOpenURL(twitterURL) {
            UIApplication.sharedApplication().openURL(twitterURL)
        } else {
            UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/GameQApp")!)
        }
    }
    @IBAction func pressedFeedback(sender: AnyObject) {
        println("pressed Feedback")
        if bolGivingFeedback {
            hideFeedbackField()
        } else {
            showFeedbackField()
            if bolChangingPassword {
                hideChangePasswordFields()
                bolChangingPassword = !bolChangingPassword
            }
        }
        bolGivingFeedback = !bolGivingFeedback
    }
    
    @IBAction func pressedChangePassword(sender: AnyObject) {
        println("pressed ChangePassword")
        if bolChangingPassword {
            hideChangePasswordFields()
        } else {
            showChangePasswordFields()
            if bolGivingFeedback {
                hideFeedbackField()
                bolGivingFeedback = !bolGivingFeedback
            }
        }
        bolChangingPassword = !bolChangingPassword
    }
    
    @IBAction func pressedTutorial(sender: AnyObject) {
        println("pressed Tutorial")
        slideMenuController()?.closeLeftNonAnimation()
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tutViewController = storyboard.instantiateViewControllerWithIdentifier("TutorialPageControl") as! TutorialPageController
        tutViewController.pageCount = 3
        tutViewController.automaticallyAdjustsScrollViewInsets = false
        tutViewController.delegate = tutViewController
        tutViewController.dataSource = tutViewController
        UIApplication.sharedApplication().delegate?.window?!.rootViewController = tutViewController
        UIApplication.sharedApplication().delegate?.window?!.makeKeyAndVisible()
        
        let tutViewController2 = storyboard.instantiateViewControllerWithIdentifier("Tutorial2") as! TutorialController2
        
        tutViewController.setViewControllers([tutViewController2], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: {
            (success:Bool) in
            println("setup pageController")
        })
        
        

    }
    
    @IBAction func pressedSubmitPassword(sender: AnyObject) {
        println("pressed SubmitPassword")
        println(txtOldPassword.text.validPassword())
        println(txtNewPassword.text.validPassword())
        println(txtConfirmPassword.text != txtNewPassword.text)
        
        if !txtOldPassword.text.validPassword() {
           println("password to short")
            hideErrors()
            txtOldPassword.showError("Password too short")
        } else if !txtNewPassword.text.validPassword() {
            println("password to short")
            hideErrors()
            txtNewPassword.showError("Password too short")
        } else if txtConfirmPassword.text != txtNewPassword.text {
            println("password to short")
            hideErrors()
            txtConfirmPassword.showError("Password mismatch")
            txtNewPassword.showError("Password mismatch")
        } else {
            disableAll()
            ConnectionHandler.updatePassword(ConnectionHandler.loadEmail()!, password: txtOldPassword.text, newPassword: txtNewPassword.text, finalCallBack: {
                (success:Bool, error:String?) in
                dispatch_async(dispatch_get_main_queue(), {
                    if success {
                        self.btnSubmitPassword.setTitle("Thanks!", forState: UIControlState.Normal)
                        self.hideErrors()
                        self.hideChangePasswordFields()
                    } else {
                        self.hideErrors()
                        self.txtOldPassword.showError(error!)
                    }
                    self.enableAll()
                    
                })
                
            })
        }
        
        
        
        
    }
    
    func hideErrors() {
        txtNewPassword.hideError()
        txtOldPassword.hideError()
        txtConfirmPassword.hideError()
    }
    @IBAction func pressedSubmitFeedback(sender: AnyObject) {
        println("pressed SubmitFeedback")
        if count(txtFeedback.text) < 5 {
            hideFeedbackField()
        } else {
            disableAll()
            ConnectionHandler.submitFeedback(txtFeedback.text, finalCallBack: {
                (success:Bool, error:String?) in
                dispatch_async(dispatch_get_main_queue(), {
                    self.enableAll()
                    self.btnSubmitFeedback.setTitle("Thanks!", forState: UIControlState.Normal)
                    self.hideFeedbackField()
                    
                })
                
            })
        }
        
    }
    
    @IBAction func pressedResignFirstResponder(sender: AnyObject) {
        txtConfirmPassword.resignFirstResponder()
        txtFeedback.resignFirstResponder()
        txtNewPassword.resignFirstResponder()
        txtOldPassword.resignFirstResponder()
    }
    @IBAction func pressedOnButtonOne(sender: OnButton) {
        println("on1")
        sender.on = true
        sender.setNeedsDisplay()
        offButtonOne.off = false
        offButtonOne.setNeedsDisplay()
        let actualToken:String? = ConnectionHandler.loadToken()
        println(actualToken!)
        ConnectionHandler.updateToken(actualToken!, finalCallBack: {
            (success:Bool, error:String?) in
            if success {
                // do nothing
            } else {
                self.offButtonOne.off = true
                self.onButtonOne.on = false
                self.offButtonOne.setNeedsDisplay()
                self.onButtonOne.setNeedsDisplay()
            }
        })
        
    }
    
    @IBAction func pressedOffButtonOne(sender: OffButton) {
        println("off1")
        sender.off = true
        sender.setNeedsDisplay()
        onButtonOne.on = false
        onButtonOne.setNeedsDisplay()
        let actualToken = ConnectionHandler.loadToken()
        ConnectionHandler.updateToken(LeftViewController.emptyString, finalCallBack: {
            (success:Bool, error:String?) in
            ConnectionHandler.saveToken(actualToken!)
            if success {
                // do nothing
            } else {
                self.offButtonOne.off = false
                self.onButtonOne.on = true
                self.offButtonOne.setNeedsDisplay()
                self.onButtonOne.setNeedsDisplay()
            }
        })
        
    }
    /*
    @IBAction func pressedOnButtonTwo(sender: OnButton) {
        println("on2")
        sender.on = true
        sender.setNeedsDisplay()
        offButtonTwo.off = false
        offButtonTwo.setNeedsDisplay()
    }
    
    @IBAction func pressedOffButtonTwo(sender: OffButton) {
        println("off2")
        sender.off = true
        sender.setNeedsDisplay()
        onButtonTwo.on = false
        onButtonTwo.setNeedsDisplay()
    }*/
    
    @IBAction func pressedOnButtonThree(sender: OnButton) {
        sender.on = true
        sender.setNeedsDisplay()
        offButtonThree.off = false
        offButtonThree.setNeedsDisplay()
    }
    
    @IBAction func pressedOffButtonThree(sender: OffButton) {
        sender.off = true
        sender.setNeedsDisplay()
        onButtonThree.on = false
        onButtonThree.setNeedsDisplay()
    }
    
    @IBAction func pressedLogout(sender: AnyObject) {
            // create viewController code...
        disableAll()
        ConnectionHandler.logout({
            (success:Bool, error:String?) in
            dispatch_async(dispatch_get_main_queue(), {
                self.enableAll()
                if !success {
                    println("logout error: \(error!)")
                }
                var storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                UIApplication.sharedApplication().delegate?.window?!.rootViewController = loginViewController
                UIApplication.sharedApplication().delegate?.window?!.makeKeyAndVisible()
            })
        })
        
        
        
    }
    
    private func disableAll() {
        btnSubmitFeedback.enabled = false
        btnSubmitPassword.enabled = false
        onButtonOne.enabled = false
        offButtonOne.enabled = false
        btnFeedback.enabled = false
        btnChangePassword.enabled = false
        btnTutorial.enabled = false
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        activityIndicator.alpha = 1.0
    }
    
    private func enableAll() {
        btnSubmitFeedback.enabled = true
        btnSubmitPassword.enabled = true
        onButtonOne.enabled = true
        offButtonOne.enabled = true
        btnFeedback.enabled = true
        btnChangePassword.enabled = true
        btnTutorial.enabled = true
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
        activityIndicator.alpha = 0.0
    }
    
    
    func showChangePasswordFields() {
        hideErrors()
        btnSubmitPassword.setTitle("Submit", forState: UIControlState.Normal)
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.changePasswordHeight.constant = 44*4 + 22
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.txtOldPassword.alpha = 1.0
            self.txtNewPassword.alpha = 1.0
            self.txtConfirmPassword.alpha = 1.0
            self.pwIcon1.alpha = 1.0
            self.pwIcon2.alpha = 1.0
            self.pwIcon3.alpha = 1.0
            self.txtOldPassword.text = ""
            self.txtNewPassword.text = ""
            self.txtConfirmPassword.text = ""
            self.btnSubmitPassword.alpha = 1.0
            }, completion: nil)
        
    }
    
    
    func hideChangePasswordFields() {
        txtOldPassword.resignFirstResponder()
        txtNewPassword.resignFirstResponder()
        txtConfirmPassword.resignFirstResponder()
        UIView.animateWithDuration(0.5, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.changePasswordHeight.constant = 44
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.txtOldPassword.alpha = 0.0
            self.txtNewPassword.alpha = 0.0
            self.txtConfirmPassword.alpha = 0.0
            self.btnSubmitPassword.alpha = 0.0
            self.pwIcon1.alpha = 0.0
            self.pwIcon2.alpha = 0.0
            self.pwIcon3.alpha = 0.0
            }, completion: nil)


    }
    
    func showFeedbackField() {
        btnSubmitFeedback.setTitle("Submit", forState: UIControlState.Normal)
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.feedbackHeight.constant = 44*4
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.txtFeedback.alpha = 1.0
            self.btnSubmitFeedback.alpha = 1.0
            }, completion: nil)
    }
    
    func hideFeedbackField() {
        txtFeedback.text = ""
        txtFeedback.resignFirstResponder()
        UIView.animateWithDuration(0.5, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.feedbackHeight.constant = 44
            self.view.layoutIfNeeded()
            }, completion: nil)
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.txtFeedback.alpha = 0.0
            self.btnSubmitFeedback.alpha = 0.0
            }, completion: nil)
    }
    
    
    
    var mainViewController: UIViewController!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLoginBackground.backgroundColor = Colors().navBackgroundGray
        lblUserEmail.text = ConnectionHandler.loadEmail()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        txtConfirmPassword.delegate = self
        txtNewPassword.delegate = self
        txtOldPassword.delegate = self
        txtFeedback.delegate = self
        if let smth = ConnectionHandler.loadOldToken() {
            if smth == LeftViewController.emptyString {
                println("off1")
                offButtonOne.off = true
                offButtonOne.setNeedsDisplay()
                onButtonOne.on = false
                onButtonOne.setNeedsDisplay()
            }
        }
        lblUserEmail.textColor = UIColor.whiteColor()
        
        btnLogout.setTitle("Logout", forState: UIControlState.Normal)
        btnLogout.setTitle("Logout", forState: UIControlState.Highlighted)
        btnLogout.setTitle("Logout", forState: UIControlState.Disabled)
        btnLogout.setTitle("Logout", forState: UIControlState.Selected)
        btnLogout.setTitle("Logout", forState: UIControlState.allZeros)
        btnLogout.setTitle("Logout", forState: UIControlState.Application)
        btnLogout.setTitle("Logout", forState: UIControlState.Reserved)
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: self.view.bounds, byRoundingCorners: .BottomRight | .TopRight, cornerRadii: CGSize(width: 10.0, height: 10.0)).CGPath
        
        self.view.layer.mask = maskLayer;
        
        self.view.backgroundColor = Colors().navBackgroundGray
        leftNavBar.backgroundColor = Colors().navTopGray
        onButtonThree.on = false
        onButtonThree.setNeedsDisplay()
        
        
    }
    
    
    //MARK Text- View/Field -Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == txtOldPassword {
            txtNewPassword.becomeFirstResponder()
        } else if textField == txtNewPassword {
            txtConfirmPassword.becomeFirstResponder()
        } else if textField == txtConfirmPassword {
            pressedSubmitPassword(btnSubmitPassword)
        }
        btnResignFirstResponder.hidden = true
        return false
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        btnResignFirstResponder.hidden = false
        currentTextField = textField
        println("didbegin")
    }
    func textFieldDidEndEditing(textField: UITextField) {
        btnResignFirstResponder.hidden = true
        
    }
    func textViewDidBeginEditing(textView: UITextView) {
        btnResignFirstResponder.hidden = false
        println("didbegin")
    }
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        println("shouldbegin")
        currentTextField = textView
        return true
    }
    func textViewDidEndEditing(textView: UITextView) {
        btnResignFirstResponder.hidden = true
        currentTextField = textView
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        println("Will show")
        self.view.layoutIfNeeded()
        if currentTextField == txtFeedback {
            
            println(txtFeedback.frame.origin.y)
            if UIScreen.mainScreen().bounds.height - keyboardFrame.size.height - 20 < txtFeedback.frame.origin.y + txtFeedback.frame.height {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.topConstraint.constant = UIScreen.mainScreen().bounds.height - keyboardFrame.size.height - 20 - self.txtFeedback.frame.origin.y - self.txtFeedback.frame.height
                    self.view.layoutIfNeeded()
                })
            }
        } else {
            if UIScreen.mainScreen().bounds.height - keyboardFrame.size.height - 20 < txtConfirmPassword.frame.origin.y + txtConfirmPassword.frame.height {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.topConstraint.constant = UIScreen.mainScreen().bounds.height - keyboardFrame.size.height - 20 - self.txtConfirmPassword.frame.origin.y - self.txtConfirmPassword.frame.height
                    self.view.layoutIfNeeded()
                })
            }
        }
        
        
        
        
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.topConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    
    //MARK Maildelegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        switch (result.value)
        {
        case MFMailComposeResultCancelled.value :
            println("mail cancelled")
            break;
        case MFMailComposeResultSaved.value:
            println("mail saved")
            break;
        case MFMailComposeResultSent.value:
            println("mail sent")
            break;
        case MFMailComposeResultFailed.value:
            println("mail send failure")
            break;
        default:
            break;
        }
        // Close the Mail Interface
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}







