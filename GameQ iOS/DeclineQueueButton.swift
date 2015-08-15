//
//  DeclineQueueButton.swift
//  GameQ iOS
//
//  Created by Ludvig Fröberg on 14/08/15.
//  Copyright (c) 2015 Fabian Wikström. All rights reserved.
//

import UIKit

@IBDesignable class DeclineQueueButton: UIButton {

    override func drawRect(rect: CGRect) {
        self.layer.backgroundColor = Colors().Orange.CGColor
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 3
        self.clipsToBounds = true
        self.titleLabel!.textColor = UIColor.whiteColor()
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.setTitleColor(Colors().NavGray, forState: UIControlState.Highlighted)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Disabled)
        self.setTitleColor(Colors().NavGray, forState: UIControlState.Selected)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Reserved)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.allZeros)
        self.layer.borderColor = Colors().Orange.CGColor
    }

}
