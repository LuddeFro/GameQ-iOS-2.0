//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit

class LeftViewController : UIViewController {
    
    @IBOutlet weak var leftNavBar: UIView!
    
    @IBOutlet weak var onButtonOne: OnButton!
    @IBOutlet weak var offButtonOne: OffButton!
    @IBOutlet weak var onButtonTwo: OnButton!
    @IBOutlet weak var offButtonTwo: OffButton!
    @IBOutlet weak var onButtonThree: OnButton!
    @IBOutlet weak var offButtonThree: OffButton!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    @IBOutlet weak var labelFour: UILabel!
    @IBOutlet weak var labelFive: UILabel!
    @IBOutlet weak var labelSix: UILabel!
    
    @IBAction func pressedOnButtonOne(sender: OnButton) {
    sender.on = true
    sender.setNeedsDisplay()
    offButtonOne.off = false
    offButtonOne.setNeedsDisplay()
    }
  
    @IBAction func pressedOffButtonOne(sender: OffButton) {
        sender.off = true
        sender.setNeedsDisplay()
        onButtonOne.on = false
        onButtonOne.setNeedsDisplay()
    }
    
    
    @IBAction func pressedOnButtonTwo(sender: OnButton) {
        sender.on = true
        sender.setNeedsDisplay()
        offButtonTwo.off = false
        offButtonTwo.setNeedsDisplay()
    }
    
    @IBAction func pressedOffButtonTwo(sender: OffButton) {
        sender.off = true
        sender.setNeedsDisplay()
        onButtonTwo.on = false
        onButtonTwo.setNeedsDisplay()
    }
    
    @IBAction func pressedOnButtonThree(sender: OnButton) {
        sender.on = true
        sender.setNeedsDisplay()
        offButtonThree.off = false
        offButtonThree.setNeedsDisplay()
    }
    
    @IBAction func pressedOffButtonThree(sender: OffButton) {
        sender.off = true
        sender.setNeedsDisplay()
        onButtonThree.on = false
        onButtonThree.setNeedsDisplay()
    }
    
    
    var mainViewController: UIViewController!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: self.view.bounds, byRoundingCorners: .BottomRight | .TopRight, cornerRadii: CGSize(width: 10.0, height: 10.0)).CGPath
        
        self.view.layer.mask = maskLayer;
        
        self.view.backgroundColor = Colors().LeftGray
        leftNavBar.backgroundColor = Colors().NavGray
        userName.textColor = Colors().NameGray
        labelOne.textColor = Colors().MenuTextGray
        labelTwo.textColor = Colors().MenuTextGray
        labelThree.textColor = Colors().MenuTextGray
        labelFour.textColor = Colors().MenuTextGray
        labelFive.textColor = Colors().MenuTextGray
        labelSix.textColor = Colors().MenuTextGray
        }
}