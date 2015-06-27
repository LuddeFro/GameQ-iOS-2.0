//
//  QueueTimer.swift
//  GameQ-OSX-2.0
//
//  Created by Fabian Wikström on 6/23/15.
//  Copyright (c) 2015 GameQ AB. All rights reserved.
//


import Foundation
import UIKit

class QueueTimer: UIView {
    
    var isRotating = false
    let rotationTime:CFTimeInterval = 4
    var isGame:Bool = false
    let π:CGFloat = CGFloat(M_PI)
    var circleRadius: CGFloat = 0
    var lineWidth: CGFloat = 0
    
    override func drawRect(dirtyRect: CGRect) {
        
        
        var rect:CGRect = circleFrame()
        
        var path = UIBezierPath(arcCenter: CGPoint(x: CGRectGetMidX(rect), y:  CGRectGetMidY(rect)), radius: circleRadius, startAngle: -π/2, endAngle: (3.0*π/2.0), clockwise: true)
        
        path.lineWidth = lineWidth
        UIColor(netHex: 0x323f4f).setStroke()
        path.stroke()
        
        if(isGame){UIColor(netHex: 0x8fd8f7).setStroke()}
        else{UIColor(netHex: 0x323f4f).setStroke()}
        path.stroke()
        
        if(isRotating){
            var path2 = UIBezierPath(arcCenter: CGPoint(x: CGRectGetMidX(rect), y:  CGRectGetMidY(rect)), radius: circleRadius, startAngle: -π/2, endAngle: -π/4, clockwise: true)
            path2.lineWidth = lineWidth
            UIColor(netHex: 0x8fd8f7).setStroke()
            path2.stroke()
        }
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        if self.isRotating == true {
            self.rotate360Degrees(duration: 4, completionDelegate: self)
        } else {
            self.reset()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        circleRadius = frame.width / 2 - 10
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        circleRadius = frame.width / 4 - 10
        self.backgroundColor = UIColor.clearColor()
    }
    
    
    func start(){
        if(isRotating == false){
            self.isRotating = true
            self.setNeedsDisplay()
            self.rotate360Degrees(duration: 4, completionDelegate: self)
        }
    }
    
    func reset() {
        self.isRotating = false
        self.setNeedsDisplay()
        self.layer.removeAllAnimations()
    }
    
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate
        }
        self.layer.addAnimation(rotateAnimation, forKey: nil)
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineWidth = frame.width/60
        circleRadius = frame.width/2 - lineWidth
    }
    
    
    func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2*circleRadius, height: 2*circleRadius)
        circleFrame.origin.x = CGRectGetMidX(bounds) - CGRectGetMidX(circleFrame)
        circleFrame.origin.y = CGRectGetMidY(bounds) - CGRectGetMidY(circleFrame)
        return circleFrame
    }
    
    func circlePath() -> UIBezierPath {
        var rect:CGRect = circleFrame()
        return UIBezierPath(arcCenter: CGPoint(x: CGRectGetMidX(rect), y:  CGRectGetMidY(rect)), radius: circleRadius, startAngle: -π/2, endAngle: (3.0*π/2.0), clockwise: true)
    }
}
