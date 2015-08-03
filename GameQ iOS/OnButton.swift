//
//  OnButton.swift
//  GameQ iOS
//
//  Created by Fabian Wikström on 6/26/15.
//  Copyright (c) 2015 Fabian Wikström. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class OnButton: UIButton{

    var on:Bool = true
    
    override func drawRect(rect: CGRect) {
    self.backgroundColor = UIColor.clearColor()
    self.layer.cornerRadius = 5
        self.layer.borderWidth = 3
        self.clipsToBounds = true
    
        //set up the width and height variables
        //for the horizontal stroke
        let plusHeight: CGFloat = 3.0
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * 0.6
        
        //create the path
        var plusPath = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        plusPath.lineWidth = plusHeight
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        plusPath.moveToPoint(CGPoint(
            x:bounds.width/2 - plusWidth/2 + 2,
            y:bounds.height/2 - 1))
        
        //add a point to the path at the end of the stroke
        plusPath.addLineToPoint(CGPoint(
            x:bounds.width/2 - plusWidth/2 + 6.5,
            y:bounds.height/2 + plusWidth/2 - 5.5))
        
//        Vertical Line
        
        //move to the start of the vertical stroke
        plusPath.moveToPoint(CGPoint(
            x:bounds.width/2 + plusWidth/2 - 3.5,
            y:bounds.height/2 - plusWidth/2 + 4.5))
        
        //add the end point to the vertical stroke
        plusPath.addLineToPoint(CGPoint(
            x:bounds.width/2 - plusWidth/2 + 5.5,
            y:bounds.height/2 + plusWidth/2 - 4.5))
        
        
        if(on){self.layer.borderColor = Colors().LightBlue.CGColor
            Colors().LightBlue.setStroke()}
        else{
            self.layer.borderColor = Colors().ButtonOffGray.CGColor
            Colors().ButtonOffGray.setStroke()}
        
        //draw the stroke
        plusPath.stroke()
    }
}