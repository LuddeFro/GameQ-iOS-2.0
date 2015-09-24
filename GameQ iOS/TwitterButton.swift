//
//  TwitterButton.swift
//  GameQ iOS
//
//  Created by Ludvig Fröberg on 30/07/15.
//  Copyright (c) 2015 GameQ AB. All rights reserved.
//

import UIKit

class TwitterButton: UIButton {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        self.layer.cornerRadius = self.frame.width/2
        self.clipsToBounds = true
        self.backgroundColor = Colors().twitterBlue
        self.layer.backgroundColor = Colors().twitterBlue.CGColor
    }


}
