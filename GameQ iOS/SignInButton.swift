//
//  SignInButton.swift
//  GameQ iOS
//
//  Created by Ludvig Fröberg on 10/07/15.
//  Copyright (c) 2015 GameQ AB. All rights reserved.
//

import UIKit

class SignInButton: UIButton {

    override func drawRect(rect: CGRect) {
        
        self.layer.backgroundColor = Colors().LightBlue.CGColor
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 3
        self.clipsToBounds = true
        self.titleLabel!.textColor = UIColor.whiteColor()
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.setTitleColor(Colors().NavGray, forState: UIControlState.Highlighted)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Disabled)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Reserved)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState())
        self.layer.borderColor = Colors().LightBlue.CGColor
    }

}
