//
//  ForgotButton.swift
//  GameQ iOS
//
//  Created by Ludvig Fröberg on 10/07/15.
//  Copyright (c) 2015 Fabian Wikström. All rights reserved.
//

import UIKit

class ForgotButton: UIButton {

    override func drawRect(rect: CGRect) {
        
        
        self.setTitleColor(Colors().MenuTextGray, forState: UIControlState.Normal)
        self.setTitleColor(Colors().NavGray, forState: UIControlState.Highlighted)
        
    }

}
