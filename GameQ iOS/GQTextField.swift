//
//  GQTextField.swift
//  GameQ iOS
//
//  Created by Ludvig Fröberg on 10/07/15.
//  Copyright (c) 2015 Fabian Wikström. All rights reserved.
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

    required init(coder aDecoder: NSCoder) {
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
        var attrString:NSMutableAttributedString = NSMutableAttributedString(string: self.placeholder!)
        attrString.addAttribute(NSForegroundColorAttributeName, value: Colors().MenuTextGray, range: NSMakeRange(0, attrString.length))
        self.attributedPlaceholder = attrString
        self.textColor = UIColor.whiteColor()
        
        
        
        
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = Colors().MenuTextGray.CGColor
        
    }

}
