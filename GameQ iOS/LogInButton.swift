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
        self.backgroundColor = UIColor.clearColor()
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 3
        self.titleLabel!.textColor = Colors().LightBlue
        self.layer.borderColor = Colors().LightBlue.CGColor
    }
}

