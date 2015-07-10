//
//  FeedbackView.swift
//  GameQ iOS
//
//  Created by Ludvig Fröberg on 10/07/15.
//  Copyright (c) 2015 Fabian Wikström. All rights reserved.
//

import UIKit

class FeedbackView: UITextView {

    override func drawRect(rect: CGRect) {
        self.layer.backgroundColor = UIColor.clearColor().CGColor
        self.backgroundColor  = UIColor.clearColor()
        self.textColor = UIColor.whiteColor()
        self.tintColor = UIColor.clearColor()
        
        
        
        
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = Colors().MenuTextGray.CGColor
        
    }

}
