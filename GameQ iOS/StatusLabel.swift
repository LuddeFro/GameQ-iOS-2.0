//
//  StatusLabel.swift
//  GameQ iOS
//
//  Created by Ludvig Fröberg on 10/07/15.
//  Copyright (c) 2015 Fabian Wikström. All rights reserved.
//

import UIKit

class StatusLabel: UILabel {

    override func drawRect(rect: CGRect) {
        self.textColor = Colors().Orange
        super.drawRect(rect)
        
        
    }

}
