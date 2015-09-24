//
//  ForgotButton.swift
//  GameQ iOS
//
//  Created by Ludvig Fröberg on 10/07/15.
//  Copyright (c) 2015 GameQ AB. All rights reserved.
//

import UIKit

class ForgotButton: UIButton {

    override func drawRect(rect: CGRect) {
        
        
        self.setTitleColor(Colors().MenuTextGray, forState: UIControlState.Normal)
        self.setTitleColor(Colors().MenuTextGray, forState: UIControlState.Highlighted)
        self.setTitleColor(Colors().MenuTextGray, forState: UIControlState.Selected)
        self.setTitleColor(Colors().MenuTextGray, forState: UIControlState.Disabled)
        
    }

}
