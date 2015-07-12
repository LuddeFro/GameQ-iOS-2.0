//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit

class LeftViewController : UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var leftNavBar: UIView!
    
    @IBOutlet weak var onButtonOne: OnButton!
    @IBOutlet weak var offButtonOne: OffButton!
    @IBOutlet weak var onButtonTwo: OnButton!
    @IBOutlet weak var offButtonTwo: OffButton!
    @IBOutlet weak var onButtonThree: OnButton!
    @IBOutlet weak var offButtonThree: OffButton!
    @IBOutlet weak var lblUserEmail: MenuLabel!
    
    @IBOutlet weak var btnResignFirstResponder: UIButton!
    @IBOutlet weak var btnTutorial: UIButton!
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var btnFeedback: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
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

    var bolChangingPassword:Bool = false
    var bolGivingFeedback:Bool = false
    
    
    
    
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
        sender.on = true
        sender.setNeedsDisplay()
        offButtonOne.off = false
        offButtonOne.setNeedsDisplay()
    }
    
    @IBAction func pressedOffButtonOne(sender: OffButton) {
        sender.off = true
        sender.setNeedsDisplay()
        onButtonOne.on = false
        onButtonOne.setNeedsDisplay()
    }
    
    @IBAction func pressedOnButtonTwo(sender: OnButton) {
        sender.on = true
        sender.setNeedsDisplay()
        offButtonTwo.off = false
        offButtonTwo.setNeedsDisplay()
    }
    
    @IBAction func pressedOffButtonTwo(sender: OffButton) {
        sender.off = true
        sender.setNeedsDisplay()
        onButtonTwo.on = false
        onButtonTwo.setNeedsDisplay()
    }
    
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
        onButtonTwo.enabled = false
        offButtonOne.enabled = false
        offButtonTwo.enabled = false
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
        onButtonTwo.enabled = true
        offButtonOne.enabled = true
        offButtonTwo.enabled = true
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
            self.changePasswordHeight.constant = 44*4
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.txtOldPassword.alpha = 1.0
            self.txtNewPassword.alpha = 1.0
            self.txtConfirmPassword.alpha = 1.0
            self.txtOldPassword.text = ""
            self.txtNewPassword.text = ""
            self.txtConfirmPassword.text = ""
            self.btnSubmitPassword.alpha = 1.0
            }, completion: nil)
        
    }
    
    
    func hideChangePasswordFields() {
        UIView.animateWithDuration(0.5, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.changePasswordHeight.constant = 44
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.txtOldPassword.alpha = 0.0
            self.txtNewPassword.alpha = 0.0
            self.txtConfirmPassword.alpha = 0.0
            self.btnSubmitPassword.alpha = 0.0
            }, completion: nil)


    }
    
    func showFeedbackField() {
        btnSubmitFeedback.setTitle("Submit", forState: UIControlState.Normal)
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.feedbackHeight.constant = 44*3
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
        lblUserEmail.text = ConnectionHandler.loadEmail()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: self.view.bounds, byRoundingCorners: .BottomRight | .TopRight, cornerRadii: CGSize(width: 10.0, height: 10.0)).CGPath
        
        self.view.layer.mask = maskLayer;
        
        self.view.backgroundColor = Colors().LeftGray
        leftNavBar.backgroundColor = Colors().NavGray
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
    }
    func textFieldDidEndEditing(textField: UITextField) {
        btnResignFirstResponder.hidden = true
    }
    func textViewDidBeginEditing(textView: UITextView) {
        btnResignFirstResponder.hidden = false
    }
    func textViewDidEndEditing(textView: UITextView) {
        btnResignFirstResponder.hidden = true
    }
    
}







