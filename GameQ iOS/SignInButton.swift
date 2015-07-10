//
//  SignInButton.swift
//  GameQ iOS
//
//  Created by Ludvig Fröberg on 10/07/15.
//  Copyright (c) 2015 Fabian Wikström. All rights reserved.
//

import UIKit

class SignInButton: UIButton {

    override func drawRect(rect: CGRect) {
        
        self.layer.backgroundColor = Colors().LightBlue.CGColor
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 3
        self.titleLabel!.textColor = UIColor.whiteColor()
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.setTitleColor(Colors().NavGray, forState: UIControlState.Highlighted)
        self.layer.borderColor = Colors().LightBlue.CGColor
    }

}
