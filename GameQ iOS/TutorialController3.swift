//
//  TutorialController3.swift
//  GameQ iOS
//
//  Created by Ludvig Fröberg on 13/07/15.
//  Copyright (c) 2015 GameQ AB. All rights reserved.
//

import UIKit

class TutorialController3: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        
        let constant:CGFloat = (adjustY.constant + (lblBreadText.frame.origin.y - imageTut.frame.origin.y - imageTut.frame.height))/2
        adjustY.constant = constant
        
        self.view.setNeedsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
    }
    @IBOutlet weak var adjustY: NSLayoutConstraint!
    
    @IBOutlet weak var lblBreadText: UILabel!
    @IBOutlet weak var imageTut: UIImageView!
    
}
