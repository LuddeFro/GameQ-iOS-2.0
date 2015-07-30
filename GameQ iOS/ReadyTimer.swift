//
//  Timer.swift
//  GameQ-OSX-2.0
//
//  Created by Fabian Wikström on 6/21/15.
//  Copyright (c) 2015 GameQ AB. All rights reserved.
//


import Foundation
import UIKit

class ReadyTimer: UIView {
    
    let π:CGFloat = CGFloat(M_PI)
    let circlePathLayer = CAShapeLayer()
    var circleRadius: CGFloat = 0
    var lineWidth: CGFloat = 0
    
    var progress: CGFloat {
        get {
            return circlePathLayer.strokeEnd
        }
        set {
            if (newValue > 1) {
                circlePathLayer.strokeEnd = 1
            } else if (newValue < 0) {
                circlePathLayer.strokeEnd = 0
            } else {
                circlePathLayer.strokeEnd = newValue
            }
        }
    }
    
    override func drawRect(dirtyRect: CGRect) {
        var rect:CGRect = circleFrame()
        
        var path = UIBezierPath(arcCenter: CGPoint(x: CGRectGetMidX(rect), y:  CGRectGetMidY(rect)), radius: circleRadius, startAngle: -π/2, endAngle: (3.0*π/2.0), clockwise: true)
        
        path.lineWidth = lineWidth
        Colors().fadedTimerGray.setStroke()
        path.stroke()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        progress = 0
        circlePathLayer.frame = bounds
        circlePathLayer.fillColor = UIColor.clearColor().CGColor
        circlePathLayer.strokeColor = Colors().readyGreen.CGColor
        layer.addSublayer(circlePathLayer)
        backgroundColor = UIColor.clearColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineWidth = frame.width/40
        circleRadius = frame.width/2 - lineWidth
        circlePathLayer.lineWidth = lineWidth
        circlePathLayer.frame = bounds
        circlePathLayer.path = circlePath().CGPath
    }
    
    func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2*circleRadius, height: 2*circleRadius)
        circleFrame.origin.x = CGRectGetMidX(circlePathLayer.bounds) - CGRectGetMidX(circleFrame)
        circleFrame.origin.y = CGRectGetMidY(circlePathLayer.bounds) - CGRectGetMidY(circleFrame)
        return circleFrame
    }
    
    func circlePath() -> UIBezierPath {
        var rect:CGRect = circleFrame()
        return UIBezierPath(arcCenter: CGPoint(x: CGRectGetMidX(rect), y:  CGRectGetMidY(rect)), radius: circleRadius, startAngle: -π/2, endAngle: (3.0*π/2.0), clockwise: true)
    }
}
