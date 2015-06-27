//
//  Divider.swift
//  GameQ iOS
//
//  Created by Fabian Wikström on 6/26/15.
//  Copyright (c) 2015 Fabian Wikström. All rights reserved.
//

import Foundation
import UIKit

class Divider: UIView{

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        UIColor.setFill(Colors().ThinLineGray)
        
    }
    
}
