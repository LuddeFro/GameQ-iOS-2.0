//
//  ViewController.swift
//  GameQ iOS
//
//  Created by Fabian Wikström on 6/25/15.
//  Copyright (c) 2015 Fabian Wikström. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var topInnerCircleInset: NSLayoutConstraint!
    @IBOutlet weak var bottomInnerCircleInset: NSLayoutConstraint!
    @IBOutlet weak var rightInnerCircleInset: NSLayoutConstraint!
    @IBOutlet weak var leftInnerCircleInset: NSLayoutConstraint!
    
    @IBOutlet weak var acceptButtonHeight: NSLayoutConstraint!
    let acceptButtonHeightInflated:CGFloat = 40
    let acceptButtonHeightDeflated:CGFloat = 0
    @IBOutlet weak var btnDecline: DeclineQueueButton!
    @IBOutlet weak var btnAccept: AcceptQueueButton!
    
    
    @IBOutlet weak var crosshairWidth2: NSLayoutConstraint!
    @IBOutlet weak var crosshairLength2: NSLayoutConstraint!
    @IBOutlet weak var crosshairWidth1: NSLayoutConstraint!
    @IBOutlet weak var crosshairLength1: NSLayoutConstraint!
    
    @IBOutlet weak var topYConstraint: NSLayoutConstraint!
    @IBOutlet weak var fourthYConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdYConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomYConstraint: NSLayoutConstraint!
    @IBOutlet weak var SecondYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var crossHair: UIView!
    @IBOutlet weak var spinner: QueueTimer!
    @IBOutlet weak var leftCrosshairArm: UIView!
    @IBOutlet weak var rightCrosshairArm: UIView!
    @IBOutlet weak var bottomCrosshairArm: UIView!
    @IBOutlet weak var topCrosshairArm: UIView!
    @IBOutlet weak var readyTimer: ReadyTimer!
    @IBOutlet weak var lblGame: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblCountdown: PulsatingLabel!
    
    let animationSemaphore = dispatch_semaphore_create(1)
    
    var bolGotLastAnswer:Bool = true
    var lastStatus:Status = Status.Offline
    var lastAcceptBefore:Int = 0
    var bolCrosshairRotationShouldStop:Bool = true
    
    var tmrStatus = NSTimer()
    var bolTimerRunning = false
    
    var tmrCountdown = NSTimer()
    var totalCountdown:Int = 0
    var endTime:Int = 0
    var startTime:Int = 0
    var tenthCounter:Int = 0
    var degrees:CGFloat = 0.0
    
    var currentGame:Game = Encoding.getGameFromInt(0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.sharedApplication().delegate as! AppDelegate).mainViewController = self
        setCrosshairColor(Colors().LightBlue)
        
        leftInnerCircleInset.constant = 10
        rightInnerCircleInset.constant = 10
        topInnerCircleInset.constant = 10
        bottomInnerCircleInset.constant = 10
        
        
        crosshairLength1.constant = self.view.frame.width/20
        crosshairWidth1.constant = self.view.frame.width/80
        crosshairLength2.constant = crosshairLength1.constant
        crosshairWidth2.constant = crosshairWidth1.constant
        
        let constant:CGFloat = (topYConstraint.constant - (lblStatus.frame.origin.y + lblStatus.frame.height - UIScreen.mainScreen().bounds.height) + SecondYConstraint.constant + thirdYConstraint.constant + fourthYConstraint.constant)/5
        
        if constant < 20.0 {
            /*topYConstraint.constant = 20
            SecondYConstraint.constant = constant-20/3
            thirdYConstraint.constant = constant-20/3*/
        } else {
            topYConstraint.constant = constant
            SecondYConstraint.constant = constant
            thirdYConstraint.constant = constant
            fourthYConstraint.constant = constant
        }
        
        
        self.view.setNeedsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
        
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        navigationController!.navigationBar.tintColor = UIColor(netHex: 0xffffff)
        navigationController!.navigationBar.barTintColor = UIColor(netHex: 0x465568)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.view.backgroundColor = Colors().MainGray
        lblStatus.text = ""
        lblGame.text = ""
        startStatusUpdates()
    }
    
    override func viewWillDisappear(animated: Bool) {
        stopStatusUpdates()
        stopReadyCountdownAt(0, deflateLeft: nil)
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    private func startStatusUpdates() {
        bolGotLastAnswer = true
        tmrStatus = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("updateStatus"), userInfo: nil, repeats: true)
        updateStatus()
    }
    
    func updateStatus() {
        if bolGotLastAnswer {
            bolGotLastAnswer = false
            ConnectionHandler.getStatus({
                (success:Bool, error:String?, aStatus:Int, aGame:Int?, acceptBefore:Int) in
                self.bolGotLastAnswer = true
                var status:Int = 0
                if let ag = aGame {
                    self.currentGame = Encoding.getGameFromInt(ag)
                }
                var game:Int = 0
                if success {
                    if aGame != nil {
                        game = aGame!
                    }
                    status = aStatus
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.lblStatus.text = Encoding.getStringFromGameStatus(game, status: status)
                    self.lblGame.text = Encoding.getStringFromGame(game, status: status)
                    switch Encoding.getStatusFromInt(status) {
                    case Status.Offline:
                        //båda av
                        
                        self.stopReadyCountdownAt(0, deflateLeft: nil)
                        self.stopRotateCrosshair()
                        self.animateThis({
                            self.spinner.isGame = false
                            self.spinner.reset()
                        })
                        break
                    case Status.Online:
                        
                        self.stopReadyCountdownAt(0, deflateLeft: nil)
                        self.startRotateCrosshair()
                        self.animateThis({
                            self.spinner.isGame = false
                            self.spinner.reset()
                        })
                        //båda av
                        break
                    case Status.InLobby:
                        
                        self.stopReadyCountdownAt(0, deflateLeft: nil)
                        self.startRotateCrosshair()
                        self.animateThis({
                            self.spinner.isGame = false
                            self.spinner.reset()
                        })
                        //båda av
                        break
                    case Status.InQueue:
                        
                        
                        
                        self.stopReadyCountdownAt(0, deflateLeft: nil)
                        self.startRotateCrosshair()
                        self.animateThis({
                            self.spinner.isGame = false
                            self.spinner.start()
                        })
                        //blå snurra
                        //röd av
                        break
                    case Status.GameReady:
                        if self.lastStatus == Status.GameReady {
                            if abs(self.lastAcceptBefore-acceptBefore) > 3 {
                                self.lastAcceptBefore = acceptBefore
                                self.lastAcceptBefore = acceptBefore
                                self.restartReadyCountdown(acceptBefore)
                                self.startRotateCrosshair()
                                self.animateThis({
                                    self.spinner.isGame = true
                                    self.spinner.reset()
                                })
                                break
                            } else {
                                break
                            }
                        }
                        self.lastAcceptBefore = acceptBefore
                        self.startReadyCountdown(acceptBefore)
                        self.startRotateCrosshair()
                        self.animateThis({
                            self.spinner.isGame = true
                            self.spinner.reset()
                        })
                        //röd börja
                        //helblå
                        break
                    case Status.InGame:
                        
                        self.stopReadyCountdownAt(1, deflateLeft: nil)
                        self.startRotateCrosshair()
                        self.animateThis({
                            self.spinner.isGame = true
                            self.spinner.reset()
                        })
                        //helorange
                        //helblå
                        break
                    }
                    
                    
                    
                    self.lastStatus = Encoding.getStatusFromInt(status)
                })
                
            })
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    private func stopStatusUpdates() {
        tmrStatus.invalidate()
    }
    
    private func stopReadyCountdownAt(fraction:CGFloat, deflateLeft:Bool?) {
        tmrCountdown.invalidate()
        bolTimerRunning = false
        
        
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            dispatch_semaphore_wait(self.animationSemaphore, DISPATCH_TIME_FOREVER)
            dispatch_async(dispatch_get_main_queue(), {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                CATransaction.setCompletionBlock({
                    dispatch_semaphore_signal(self.animationSemaphore)
                })
                var ba:CABasicAnimation = CABasicAnimation(keyPath: "")
                
                
//                CABasicAnimation *animation =
//                    [CABasicAnimation animationWithKeyPath:@"position"];
//                [animation setFromValue:[NSValue valueWithPoint:startPoint]];
//                [animation setToValue:[NSValue valueWithPoint:endPoint]];
//                [animation setDuration:5.0];
//                
//                [layer addAnimation:animation forKey:@"position"];
                
                
                self.readyTimer.progress = fraction
                CATransaction.commit()
            })
        })
        
        animateThis({
            
            self.lblCountdown.text = ""
            self.lblCountdown.stopPulsating()
        })
        
        if let ll = deflateLeft {
            if ll {
                deflateAcceptButtonFirst()
            } else {
                deflateDeclineButtonFirst()
            }
        } else {
            deflateAcceptButtons()
        }
    }
    
    private func animateThis(animBlock:() -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            dispatch_semaphore_wait(self.animationSemaphore, DISPATCH_TIME_FOREVER)
            dispatch_async(dispatch_get_main_queue(), {
                animBlock()
                dispatch_semaphore_signal(self.animationSemaphore)
            })
        })
    }
    
    func startReadyCountdown(to:Int) {
        if bolTimerRunning {
            return
        }
        bolTimerRunning = true
        endTime = to + ConnectionHandler.delayToServer
        
        switch currentGame {
        case Game.CSGO:
            startTime = endTime - 20
            inflateAcceptButtons()
        case Game.Dota2:
            startTime = endTime - 45
            inflateAcceptButtons()
        case Game.LoL:
            startTime = endTime - 10
            inflateAcceptButtons()
        default:
            startTime = endTime - 5
            deflateAcceptButtons()
        }
        totalCountdown = endTime - startTime
        tmrCountdown.invalidate()
        tmrCountdown = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("decrement"), userInfo: nil, repeats: true)
        animateThis({
            self.lblCountdown.startPulsating(Colors().LightBlue)
        })
    }
    
    func restartReadyCountdown(to:Int) {
        bolTimerRunning = true
        endTime = to + ConnectionHandler.delayToServer
        
        switch currentGame {
        case Game.CSGO:
            startTime = endTime - 20
            inflateAcceptButtons()
        case Game.Dota2:
            startTime = endTime - 45
            inflateAcceptButtons()
        case Game.LoL:
            startTime = endTime - 10
            inflateAcceptButtons()
        default:
            startTime = endTime - 5
            deflateAcceptButtons()
        }
        totalCountdown = endTime - startTime
        tmrCountdown.invalidate()
        tmrCountdown = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("decrement"), userInfo: nil, repeats: true)
        animateThis({
            self.lblCountdown.startPulsating(Colors().LightBlue)
        })
    }
    
    func decrement() {
        if tenthCounter >= 10 {
            decrementCountdownLabel()
            tenthCounter = 0
        }
        tenthCounter++
        animateThis({
            self.readyTimer.progress = CGFloat(Double(Double(NSDate().timeIntervalSince1970)-Double(self.startTime)) / Double(self.totalCountdown))
        })
    }
    
    private func decrementCountdownLabel() {
        lblCountdown.alpha = 1.0
        UIView.animateWithDuration(1, delay: 0, options:nil, animations: {
            self.lblCountdown.alpha = 0
            }, completion: nil)
        if endTime - Int(NSDate().timeIntervalSince1970) < 0 {
            animateThis({
                self.lblCountdown.text = ""
            })
            tmrCountdown.invalidate()
            bolTimerRunning = false
        } else {
            animateThis({
                self.lblCountdown.text = "\(self.endTime - Int(NSDate().timeIntervalSince1970))"
            })
        }
        animateThis({
            self.lblCountdown.stopPulsating()
        })
    }
    
    private func setCrosshairColor(color:UIColor)->() {
        bottomCrosshairArm.backgroundColor = color
        topCrosshairArm.backgroundColor = color
        leftCrosshairArm.backgroundColor = color
        rightCrosshairArm.backgroundColor = color
    }
    
    private func startRotateCrosshair() {
        if bolCrosshairRotationShouldStop {
            crossHair.setTranslatesAutoresizingMaskIntoConstraints(false)
            bolCrosshairRotationShouldStop = false
            rotateOnce(false)
        }
    }
    private func rotateOnce(firstTimeOrSuccess:Bool) -> Void {
        if degrees == -CGFloat(2*M_PI) {
            degrees = 0
        }
        degrees -= CGFloat(M_PI*0.5)
        if bolCrosshairRotationShouldStop {
            UIView.animateWithDuration(4, delay: 0, options: .CurveEaseOut, animations: {
                let transform:CGAffineTransform = CGAffineTransformRotate(CGAffineTransformIdentity, self.degrees)
                self.crossHair.transform = transform
                }, completion: nil)
        } else if !firstTimeOrSuccess {
            UIView.animateWithDuration(4, delay: 0, options: .CurveEaseIn, animations: {
                let transform:CGAffineTransform = CGAffineTransformRotate(CGAffineTransformIdentity, self.degrees)
                self.crossHair.transform = transform
                }, completion: rotateOnce)
        } else {
            UIView.animateWithDuration(3, delay: 0, options: .CurveLinear, animations: {
                let transform:CGAffineTransform = CGAffineTransformRotate(CGAffineTransformIdentity, self.degrees)
                self.crossHair.transform = transform
                }, completion: rotateOnce)
        }
    }
    
    private func stopRotateCrosshair() {
        bolCrosshairRotationShouldStop = true
    }
    
    
    private func inflateAcceptButtons() {
        //        println("infalting buttons")
        println("waiting 3")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            dispatch_semaphore_wait(self.animationSemaphore, DISPATCH_TIME_FOREVER)
            dispatch_async(dispatch_get_main_queue(), {
                self.btnAccept.setNeedsDisplay()
                self.btnDecline.setNeedsDisplay()
                UIView.animateWithDuration(1, delay: 0, options: .CurveEaseInOut, animations: {
                    self.acceptButtonHeight.constant = self.acceptButtonHeightInflated
                    self.btnAccept.enabled = true
                    self.btnAccept.alpha = 1.0
                    self.btnDecline.alpha = 1.0
                    self.btnDecline.enabled = true
                    self.view.layoutIfNeeded()
                    }, completion: { (success:Bool) in
                        println("signal 3")
                        dispatch_semaphore_signal(self.animationSemaphore)
                })
            })
        })
        
        
        
    }
    
    private func deflateAcceptButtons() {
        //        println("deflating buttons")
        println("waiting 4")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            dispatch_semaphore_wait(self.animationSemaphore, DISPATCH_TIME_FOREVER)
            dispatch_async(dispatch_get_main_queue(), {
                self.deflateAccept(0, duration: 1)
                self.deflateDecline(0, duration: 1)
                self.deflateAcceptButtonHeights(0.4)
            })
        })
        
    }
    
    private func deflateAcceptButtonFirst() {
        println("waiting 5")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            dispatch_semaphore_wait(self.animationSemaphore, DISPATCH_TIME_FOREVER)
            dispatch_async(dispatch_get_main_queue(), {
                self.deflateAccept(0, duration: 0.4)
                self.deflateDecline(0, duration: 1)
                self.deflateAcceptButtonHeights(1)
            })
        })
    }
    private func deflateDeclineButtonFirst() {
        println("waiting 6")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            dispatch_semaphore_wait(self.animationSemaphore, DISPATCH_TIME_FOREVER)
            dispatch_async(dispatch_get_main_queue(), {
                self.deflateDecline(0, duration: 0.4)
                self.deflateAccept(0, duration: 1)
                self.deflateAcceptButtonHeights(1)
            })
        })
        
    }
    
    private func deflateAccept(delay:NSTimeInterval, duration:NSTimeInterval) {
        UIView.animateWithDuration(duration, delay: delay, options: .CurveEaseInOut, animations: {
            self.btnAccept.enabled = false
            self.btnAccept.alpha = 0.0
            }, completion: nil)
    }
    private func deflateDecline(delay:NSTimeInterval, duration:NSTimeInterval) {
        UIView.animateWithDuration(duration, delay: delay, options: .CurveEaseInOut, animations: {
            self.btnDecline.alpha = 0.0
            self.btnDecline.enabled = false
            }, completion: nil)
    }
    private func deflateAcceptButtonHeights(delay:NSTimeInterval) {
        UIView.animateWithDuration(1, delay: delay, options: .CurveEaseInOut, animations: {
            self.acceptButtonHeight.constant = self.acceptButtonHeightDeflated
            self.view.layoutIfNeeded()
            }, completion: { (success:Bool) in
                println("signal 456")
                dispatch_semaphore_signal(self.animationSemaphore)
                
        })
    }
    
    @IBAction func pressedAccept(sender: AnyObject) {
        //        println("pressed accept")
        btnAccept.enabled = false
        btnDecline.enabled = false
        stopReadyCountdownAt(1, deflateLeft:false)
        
        
        ConnectionHandler.acceptQueue(true, finalCallBack: {
            (success:Bool, error:String?) in
            
        })
    }
    @IBAction func pressedDecline(sender: AnyObject) {
        //        println("pressed decline")
        btnDecline.enabled = false
        btnAccept.enabled = false
        stopReadyCountdownAt(0, deflateLeft:true)
        
        ConnectionHandler.acceptQueue(false, finalCallBack: {
            (success:Bool, error:String?) in
            
        })
    }
    
    
    
    
}

