//
//  GQTextField.swift
//  GameQ iOS
//
//  Created by Ludvig Fröberg on 10/07/15.
//  Copyright (c) 2015 GameQ AB. All rights reserved.
//

import UIKit

class GQTextField: UITextField {

    var lblStatus:UILabel = UILabel()
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        lblStatus.frame = CGRectMake(70, 10, self.frame.width-80, 10)
        lblStatus.textAlignment = NSTextAlignment.Right
        lblStatus.alpha = 0.0
        lblStatus.font = UIFont.boldSystemFontOfSize(10.0)
        lblStatus.textColor = Colors().Orange
        lblStatus.backgroundColor = UIColor.clearColor()
        self.addSubview(lblStatus)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        lblStatus.frame = CGRectMake(70, 10, self.frame.width-80, 10)
        lblStatus.textAlignment = NSTextAlignment.Right
        lblStatus.alpha = 0.0
        lblStatus.font = UIFont.boldSystemFontOfSize(10.0)
        lblStatus.textColor = Colors().Orange
        lblStatus.backgroundColor = UIColor.clearColor()
        self.addSubview(lblStatus)
    }
    
    func showError(status:String) {
        lblStatus.alpha = 1.0
        lblStatus.text = status
        self.layer.borderColor = UIColor.redColor().CGColor
    }
    
    func hideError() {
        lblStatus.alpha = 0.0
        self.layer.borderColor = Colors().MenuTextGray.CGColor
    }
    
    
    override func drawRect(rect: CGRect) {
        self.layer.backgroundColor = UIColor.clearColor().CGColor
        self.backgroundColor  = UIColor.clearColor()
        
        let attrString:NSMutableAttributedString = NSMutableAttributedString(string: self.placeholder!)
        attrString.addAttribute(NSForegroundColorAttributeName, value: Colors().MenuTextGray, range: NSMakeRange(0, attrString.length))
        self.attributedPlaceholder = attrString
        self.textColor = UIColor.whiteColor()
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = Colors().ThinLineGray.CGColor
        border.frame = CGRect(x: 0, y: self.layer.frame.size.height - width, width:  self.layer.frame.size.width, height: self.layer.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
//        self.layer.masksToBounds = true
        
//        self.layer.cornerRadius = 5
//        self.layer.borderWidth = 1
        //self.layer.borderColor = Colors().MenuTextGray.CGColor
        
    }
    
    let padding = UIEdgeInsets(top: 0, left:33, bottom: 0, right: 5);
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    private func newBounds(bounds: CGRect) -> CGRect {
        
        var newBounds = bounds
        newBounds.origin.x += padding.left
        newBounds.origin.y += padding.top
        newBounds.size.height -= padding.top + padding.bottom
        newBounds.size.width -= padding.left + padding.right
        return newBounds
    }
}
