//
//  LogOutButton.swift
//  GameQ iOS
//
//  Created by Fabian Wikström on 6/27/15.
//  Copyright (c) 2015 Fabian Wikström. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class LogOutButton: UIButton {
    
    override func drawRect(rect: CGRect) {
        
        self.layer.backgroundColor = Colors().Orange.CGColor
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 3
        self.clipsToBounds = true
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Disabled)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Reserved)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.allZeros)
        
        self.layer.borderColor = Colors().Orange.CGColor
    }
}

