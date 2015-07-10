//
//  LogInButton.swift
//  GameQ iOS
//
//  Created by Fabian Wikström on 6/27/15.
//  Copyright (c) 2015 Fabian Wikström. All rights reserved.
//


import Foundation
import UIKit


@IBDesignable class LogInButton: UIButton {
    
    override func drawRect(rect: CGRect) {
        self.layer.backgroundColor = Colors().Orange.CGColor
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 3
        self.titleLabel!.textColor = UIColor.whiteColor()
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.setTitleColor(Colors().NavGray, forState: UIControlState.Highlighted)
        self.layer.borderColor = Colors().Orange.CGColor
    }
}

