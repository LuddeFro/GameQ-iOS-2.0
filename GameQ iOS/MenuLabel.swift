//
//  MenuLabel.swift
//  GameQ iOS
//
//  Created by Ludvig Fröberg on 10/07/15.
//  Copyright (c) 2015 Fabian Wikström. All rights reserved.
//

import UIKit

class MenuLabel: UILabel {

    override func drawRect(rect: CGRect) {
        self.textColor = Colors().MenuTextGray
        super.drawRect(rect)
        
    }
}
