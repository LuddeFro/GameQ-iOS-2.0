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
    
    @IBOutlet weak var btnBottom: LogInButton!
    @IBOutlet weak var btnTop: LogInButton!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var txtEmail: GQTextField!
    @IBOutlet weak var txtPassword: GQTextField!
    @IBOutlet weak var txtConfirmPassword: GQTextField!
    @IBOutlet weak var btnForgot: UIButton!
    
    @IBOutlet weak var btnResignKeyboard: UIButton!
    var bolReportingForgottenPassword:Bool = false
    var bolSigningUp:Bool = false
    
    @IBOutlet weak var statusYMargin: NSLayoutConstraint!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors().MainGray
        println("SHA::::")
        println(ConnectionHandler.sha256("hejsan"))
        txtEmail.delegate = self
        txtPassword.delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        disableAll()
        ConnectionHandler.loginWithRememberedDetails({
            (success:Bool, error:String?) in
            dispatch_async(dispatch_get_main_queue()) {
                self.enableAll()
                if success {
                    //go to main view
                    self.createMainView()
                } else {
                    //do nothing
                }
            }
        })

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
                            //go to main menu
                            self.createMainView()
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
                ConnectionHandler.login(txtEmail.text, password: txtPassword.text, finalCallBack: {
                    (success:Bool, error:String?) in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.enableAll()
                        if success {
                            //go to main menu
                            self.createMainView()
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
        
        self.btnBottom.setTitle("Back", forState: UIControlState.Normal)
        self.btnTop.setTitle("Join", forState: UIControlState.Normal)
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.txtConfirmPassword.alpha = 1.0
            self.lblStatus.text = ""
            self.btnForgot.alpha = 0.0
            self.statusYMargin.constant += 37
            self.txtConfirmPassword.text = ""
            
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func hideSignUp() {
        println("hideS")
        self.txtConfirmPassword.text = ""
        self.btnBottom.setTitle("Join", forState: UIControlState.Normal)
        self.btnTop.setTitle("Sign In", forState: UIControlState.Normal)
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.txtConfirmPassword.alpha = 0.0
            self.btnForgot.alpha = 1.0
            self.statusYMargin.constant -= 37
            self.lblStatus.text = ""
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func showForgotPassword() {
        println("showF")
        self.btnBottom.setTitle("Back", forState: UIControlState.Normal)
        self.btnTop.setTitle("Submit Email", forState: UIControlState.Normal)
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.statusYMargin.constant -= 37
            self.btnForgot.alpha = 0.0
            self.lblStatus.text = ""
            self.txtPassword.text = ""
            self.txtPassword.alpha = 0.0
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func hideForgotPassword() {
        println("hideF")
        self.btnBottom.setTitle("Join", forState: UIControlState.Normal)
        self.btnTop.setTitle("Sign In", forState: UIControlState.Normal)
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.statusYMargin.constant += 37
            self.btnForgot.alpha = 1.0
            self.lblStatus.text = ""
            self.lblStatus.textColor = Colors().Orange
            self.txtPassword.alpha = 1.0
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
    }
    
                                             
    
    
}




