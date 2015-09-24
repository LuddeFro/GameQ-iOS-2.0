//
//  DividerLine.swift
//  GameQ iOS
//
//  Created by Fabian Wikström on 6/27/15.
//  Copyright (c) 2015 GameQ AB. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class DividerLine: UIView{
    
    override func drawRect(rect: CGRect) {
     Colors().ThinLineGray.setFill()
     UIRectFill(rect)
     super.drawRect(rect)
    }
}